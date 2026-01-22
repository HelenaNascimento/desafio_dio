import textwrap
from sqlalchemy import create_engine, Column, String, Float, Integer
from sqlalchemy.orm import declarative_base, sessionmaker

# --- CONFIGURAÇÃO DO BD ---
engine = create_engine('sqlite:///bd_banco.db')
Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

# --- MODELO DO USUÁRIO --- #
class Usuario(Base):
    __tablename__ = "usuarios"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    cpf = Column(String, unique=True, nullable=False)
    agencia = Column(String, default="0001")
    nome = Column(String, nullable=False)
    data_nascimento = Column(String)
    endereco = Column(String)
    senha = Column(String, nullable=False)
    saldo = Column(Float, default=0.0)
    extrato = Column(String, default="")

# Criar tabelas
Base.metadata.create_all(engine)

# --- FUNÇÕES DE OPERAÇÃO --- #

def depositar(usuario):
    try:
        valor = float(input("Informe o valor do depósito: "))
        if valor > 0:
            usuario.saldo += valor
            usuario.extrato += f"Depósito: R$ {valor:.2f}\n"
            session.commit()
            print("\n=== Depósito realizado com sucesso! ===")
        else:
            print("\n  Operação falhou! O valor informado é inválido.  ")
    except ValueError:
        print("\n  Erro: Digite apenas números para o valor.  ")

def sacar(usuario):
    try:
        valor = float(input("Informe o valor do saque: "))
        limite = 500
        LIMITE_SAQUES = 3
        numero_saques = usuario.extrato.count("Saque:")

        if valor > usuario.saldo:
            print("\n  Operação falhou! Você não tem saldo suficiente.  ")
        elif valor > limite:
            print("\n  Operação falhou! O valor do saque excede o limite.  ")
        elif numero_saques >= LIMITE_SAQUES:
            print("\n  Operação falhou! Número máximo de saques excedido.  ")
        elif valor > 0:
            usuario.saldo -= valor
            usuario.extrato += f"Saque: R$ {valor:.2f}\n"
            session.commit()
            print("\n=== Saque realizado com sucesso! ===")
        else:
            print("\n  Operação falhou! O valor informado é inválido.  ")
    except ValueError:
        print("\n  Erro: Digite apenas números para o valor.  ")

def exibir_extrato(usuario):
    
    conta_formatada = f"{usuario.id:04d}"
    
    print("\n================ EXTRATO ================")
    print(f"Titular: {usuario.nome}")
    print(f"Agência: {usuario.agencia} | Conta: {conta_formatada}")
    print("-" * 42)
    print("Não foram realizadas movimentações." if not usuario.extrato else usuario.extrato)
    print("-" * 42)
    print(f"Saldo atual: R$ {usuario.saldo:.2f}")
    print("==========================================")

# --- ACESSO --- #

def criar_conta():
    cpf = input("Informe o CPF (somente números): ")
    
    # Verifica se CPF já existe
    usuario_existente = session.query(Usuario).filter_by(cpf=cpf).first()
    if usuario_existente:
        print("\n  Erro: Já existe uma conta vinculada a este CPF!  ")
        return

    nome = input("Informe o nome completo: ")
    data_nascimento = input("Informe a data de nascimento (dd-mm-aaaa): ")
    endereco = input("Informe o endereço: ")
    senha = input("Crie uma senha de acesso: ")

    novo_usuario = Usuario(
        cpf=cpf, 
        nome=nome, 
        data_nascimento=data_nascimento, 
        endereco=endereco, 
        senha=senha
    )
    
    session.add(novo_usuario)
    session.commit()
    

    conta_formatada = f"{novo_usuario.id:04d}"
    print("\n=== Conta criada com sucesso! ===")
    print(f"Titular: {novo_usuario.nome} | Agência: {novo_usuario.agencia} | Conta: {conta_formatada}")

def realizar_login():
    cpf = input("Informe seu CPF: ")
    senha = input("Informe sua senha: ")
    
    usuario = session.query(Usuario).filter_by(cpf=cpf, senha=senha).first()
    
    if usuario:
        print(f"\nBem-vindo, {usuario.nome}!")
        menu_interno(usuario)
    else:
        print("\n  CPF ou Senha incorretos.  ")

def menu_interno(usuario):
    while True:
        opcao = input(textwrap.dedent("""
            \n=== MENU OPERACIONAL ===
            [d] Depositar
            [s] Sacar
            [e] Extrato
            [q] Sair da Conta
            => """))

        if opcao == "d":
            depositar(usuario)
        elif opcao == "s":
            sacar(usuario)
        elif opcao == "e":
            exibir_extrato(usuario)
        elif opcao == "q":
            break
        else:
            print("\n  Operação inválida!  ")

def main():
    while True:
        acesso = input(textwrap.dedent("""
            \n=== SISTEMA BANCÁRIO ===
            [e] Entrar (Login)
            [c] Criar nova conta
            [q] Sair do sistema
            => """))

        if acesso == "e":
            realizar_login()
        elif acesso == "c":
            criar_conta()
        elif acesso == "q":
            print("\nSaindo... Até logo!")
            break
        else:
            print("\n  Opção inválida!  ")

if __name__ == "__main__":
    main()