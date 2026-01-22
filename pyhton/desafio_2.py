import textwrap
from abc import ABC, abstractmethod
from datetime import datetime
from sqlalchemy import create_engine, Column, String, Float, Integer, ForeignKey, DateTime
from sqlalchemy.orm import declarative_base, sessionmaker, relationship

#   CONFIGURAÇÃO DO ALCHEMY  
Base = declarative_base()
engine = create_engine('sqlite:///banco_sistema_v3.db')
Session = sessionmaker(bind=engine)
session = Session()

#   MODELOS E CLASSES  

class Cliente(Base):
    __tablename__ = 'clientes'
    
    # No diagrama: endereco: str
    endereco = Column(String)
    # PessoaFisica (Herança simplificada para o banco)
    cpf = Column(String, primary_key=True)
    nome = Column(String, nullable=False)
    data_nascimento = Column(String)
    
    contas_rel = relationship("Conta", back_populates="cliente_rel")

    def __init__(self, nome, data_nascimento, cpf, endereco):
        self.nome = nome
        self.data_nascimento = data_nascimento
        self.cpf = cpf
        self.endereco = endereco

    def realizar_transacao(self, conta, transacao):
        transacao.registrar(conta)

    def adicionar_conta(self, conta):
        # O SQLAlchemy gerencia a lista via relationship
        pass

class Conta(Base):
    __tablename__ = 'contas'
    
    id = Column(Integer, primary_key=True, autoincrement=True) # Número sequencial
    agencia = Column(String, default="0001")
    saldo_db = Column(Float, default=0.0)
    tipo = Column(String) # Para distinguir ContaCorrente no banco
    
    cliente_id = Column(String, ForeignKey('clientes.cpf'))
    cliente_rel = relationship("Cliente", back_populates="contas_rel")
    transacoes_rel = relationship("HistoricoModel", back_populates="conta_rel")

    __mapper_args__ = {
        'polymorphic_on': tipo,
        'polymorphic_identity': 'conta'
    }

    def __init__(self, cliente):
        self.cliente_rel = cliente
        self.saldo_db = 0.0
        self.agencia = "0001"

    @property
    def saldo(self):
        return self.saldo_db

    @property
    def numero(self):
        return self.id

    def sacar(self, valor):
        if valor > self.saldo_db:
            print("\n  Operação falhou! Você não tem saldo suficiente.  ")
            return False
        
        if valor > 0:
            self.saldo_db -= valor
            print("\n=== Saque realizado com sucesso! ===")
            return True
        
        print("\n  Operação falhou! Valor inválido.  ")
        return False

    def depositar(self, valor):
        if valor > 0:
            self.saldo_db += valor
            print("\n=== Depósito realizado com sucesso! ===")
            return True
        
        print("\n  Operação falhou! Valor inválido.  ")
        return False

class ContaCorrente(Conta):
    __tablename__ = 'contas_correntes'
    id = Column(Integer, ForeignKey('contas.id'), primary_key=True)
    limite = Column(Float, default=500.0)
    limite_saques = Column(Integer, default=3)

    __mapper_args__ = {
        'polymorphic_identity': 'conta_corrente',
    }

    def __init__(self, cliente, limite=500, limite_saques=3):
        super().__init__(cliente)
        self.limite = limite
        self.limite_saques = limite_saques

    def sacar(self, valor):
        # Conta saques no histórico do banco
        hoje = datetime.now().date()
        numero_saques = session.query(HistoricoModel).filter(
            HistoricoModel.conta_id == self.id,
            HistoricoModel.tipo == "Saque"
        ).count()

        if valor > self.limite:
            print("\n  Operação falhou! O valor excede o limite.  ")
        elif numero_saques >= self.limite_saques:
            print("\n  Operação falhou! Limite de saques excedido.  ")
        else:
            return super().sacar(valor)
        return False

class HistoricoModel(Base):
    """Persistência do Histórico do Diagrama UML"""
    __tablename__ = 'historico'
    id = Column(Integer, primary_key=True)
    tipo = Column(String)
    valor = Column(Float)
    data = Column(String)
    conta_id = Column(Integer, ForeignKey('contas.id'))
    
    conta_rel = relationship("Conta", back_populates="transacoes_rel")

class Transacao(ABC):
    @property
    @abstractmethod
    def valor(self): pass

    @abstractmethod
    def registrar(self, conta): pass

class Saque(Transacao):
    def __init__(self, valor):
        self._valor = valor

    @property
    def valor(self): return self._valor

    def registrar(self, conta):
        if conta.sacar(self.valor):
            historico = HistoricoModel(
                tipo="Saque", 
                valor=self.valor, 
                data=datetime.now().strftime("%d-%m-%Y %H:%M"),
                conta_id=conta.id
            )
            session.add(historico)
            session.commit()

class Deposito(Transacao):
    def __init__(self, valor):
        self._valor = valor

    @property
    def valor(self): return self._valor

    def registrar(self, conta):
        if conta.depositar(self.valor):
            historico = HistoricoModel(
                tipo="Depósito", 
                valor=self.valor, 
                data=datetime.now().strftime("%d-%m-%Y %H:%M"),
                conta_id=conta.id
            )
            session.add(historico)
            session.commit()

# Criar Tabelas
Base.metadata.create_all(engine)

#   FUNÇÕES DE OPERAÇÃO  

def criar_conta():
    cpf = input("Informe o CPF (somente números): ")
    cliente_existente = session.query(Cliente).filter_by(cpf=cpf).first()

    if cliente_existente:
        print("\n  Alerta: Este CPF já possui uma conta ativa!  ")
        return

    nome = input("Nome completo: ")
    data_nascimento = input("Data de nascimento (dd-mm-aaaa): ")
    endereco = input("Endereço: ")

    novo_cliente = Cliente(nome, data_nascimento, cpf, endereco)
    nova_conta = ContaCorrente(cliente=novo_cliente)
    
    session.add(novo_cliente)
    session.add(nova_conta)
    session.commit()
    
    print(f"\n=== Conta {nova_conta.id:04d} criada com sucesso para {nome}! ===")

def listar_extrato():
    cpf = input("Informe o CPF: ")
    cliente = session.query(Cliente).filter_by(cpf=cpf).first()
    
    if not cliente or not cliente.contas_rel:
        print("\n  Cliente não encontrado ou sem contas!  ")
        return

    conta = cliente.contas_rel[0]
    print("\n================ EXTRATO ================")
    print(f"Titular: {cliente.nome}")
    print(f"Agência: {conta.agencia} | C/C: {conta.id:04d}")
    print("-" * 40)
    
    transacoes = session.query(HistoricoModel).filter_by(conta_id=conta.id).all()
    if not transacoes:
        print("Não foram realizadas movimentações.")
    else:
        for t in transacoes:
            print(f"{t.data} - {t.tipo}:\tR$ {t.valor:.2f}")
            
    print("-" * 40)
    print(f"Saldo atual:\tR$ {conta.saldo:.2f}")
    print("==========================================")

def realizar_operacao(tipo):
    cpf = input("Informe o CPF: ")
    cliente = session.query(Cliente).filter_by(cpf=cpf).first()
    
    if cliente and cliente.contas_rel:
        conta = cliente.contas_rel[0]
        valor = float(input(f"Informe o valor do {tipo}: "))
        
        transacao = Saque(valor) if tipo == "saque" else Deposito(valor)
        cliente.realizar_transacao(conta, transacao)
    else:
        print("\n  Conta não encontrada!  ")

def main():
    while True:
        menu = input(textwrap.dedent("""
            \n=== MENU ===
            [c] Criar Conta
            [d] Depositar
            [s] Sacar
            [e] Extrato
            [q] Sair
            => """))

        if menu == "c": criar_conta()
        elif menu == "d": realizar_operacao("depósito")
        elif menu == "s": realizar_operacao("saque")
        elif menu == "e": listar_extrato()
        elif menu == "q": break

if __name__ == "__main__":
    main()