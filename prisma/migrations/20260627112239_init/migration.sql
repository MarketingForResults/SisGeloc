-- CreateEnum
CREATE TYPE "Perfil" AS ENUM ('ADMIN', 'OPERADOR', 'VISUALIZADOR');

-- CreateEnum
CREATE TYPE "TipoPessoa" AS ENUM ('FISICA', 'JURIDICA');

-- CreateEnum
CREATE TYPE "StatusVeiculo" AS ENUM ('DISPONIVEL', 'ALUGADO', 'MANUTENCAO', 'INATIVO');

-- CreateEnum
CREATE TYPE "StatusLocacao" AS ENUM ('RESERVADO', 'EM_ANDAMENTO', 'DEVOLVIDO', 'CANCELADO', 'INADIMPLENTE');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "perfil" "Perfil" NOT NULL DEFAULT 'OPERADOR',
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "proprietarios" (
    "id" TEXT NOT NULL,
    "tipo" "TipoPessoa" NOT NULL DEFAULT 'FISICA',
    "nome" TEXT NOT NULL,
    "cpfCnpj" TEXT NOT NULL,
    "rg" TEXT,
    "email" TEXT NOT NULL,
    "telefone" TEXT NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "proprietarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "enderecos" (
    "id" TEXT NOT NULL,
    "cep" TEXT NOT NULL,
    "logradouro" TEXT NOT NULL,
    "numero" TEXT NOT NULL,
    "complemento" TEXT,
    "bairro" TEXT NOT NULL,
    "cidade" TEXT NOT NULL,
    "estado" TEXT NOT NULL,
    "proprietarioId" TEXT,
    "motoristaid" TEXT,

    CONSTRAINT "enderecos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "motoristas" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "dataNascimento" TIMESTAMP(3) NOT NULL,
    "telefone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "cnh" TEXT NOT NULL,
    "categoriaCnh" TEXT NOT NULL,
    "validadeCnh" TIMESTAMP(3) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "bloqueado" BOOLEAN NOT NULL DEFAULT false,
    "motivoBloqueio" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "motoristas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "veiculos" (
    "id" TEXT NOT NULL,
    "placa" TEXT NOT NULL,
    "chassi" TEXT NOT NULL,
    "renavam" TEXT NOT NULL,
    "marca" TEXT NOT NULL,
    "modelo" TEXT NOT NULL,
    "anoFabricacao" INTEGER NOT NULL,
    "anoModelo" INTEGER NOT NULL,
    "cor" TEXT NOT NULL,
    "combustivel" TEXT NOT NULL,
    "cambio" TEXT NOT NULL,
    "status" "StatusVeiculo" NOT NULL DEFAULT 'DISPONIVEL',
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "proprietarioId" TEXT NOT NULL,

    CONSTRAINT "veiculos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locacoes" (
    "id" TEXT NOT NULL,
    "dataInicio" TIMESTAMP(3) NOT NULL,
    "dataFim" TIMESTAMP(3) NOT NULL,
    "valorDiaria" DECIMAL(10,2) NOT NULL,
    "valorTotal" DECIMAL(10,2),
    "status" "StatusLocacao" NOT NULL DEFAULT 'RESERVADO',
    "observacoes" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "veiculoId" TEXT NOT NULL,
    "motoristaid" TEXT NOT NULL,

    CONSTRAINT "locacoes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "proprietarios_cpfCnpj_key" ON "proprietarios"("cpfCnpj");

-- CreateIndex
CREATE UNIQUE INDEX "proprietarios_email_key" ON "proprietarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "enderecos_proprietarioId_key" ON "enderecos"("proprietarioId");

-- CreateIndex
CREATE UNIQUE INDEX "enderecos_motoristaid_key" ON "enderecos"("motoristaid");

-- CreateIndex
CREATE UNIQUE INDEX "motoristas_cpf_key" ON "motoristas"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "motoristas_email_key" ON "motoristas"("email");

-- CreateIndex
CREATE UNIQUE INDEX "motoristas_cnh_key" ON "motoristas"("cnh");

-- CreateIndex
CREATE UNIQUE INDEX "veiculos_placa_key" ON "veiculos"("placa");

-- CreateIndex
CREATE UNIQUE INDEX "veiculos_chassi_key" ON "veiculos"("chassi");

-- CreateIndex
CREATE UNIQUE INDEX "veiculos_renavam_key" ON "veiculos"("renavam");

-- AddForeignKey
ALTER TABLE "enderecos" ADD CONSTRAINT "enderecos_proprietarioId_fkey" FOREIGN KEY ("proprietarioId") REFERENCES "proprietarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "enderecos" ADD CONSTRAINT "enderecos_motoristaid_fkey" FOREIGN KEY ("motoristaid") REFERENCES "motoristas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "veiculos" ADD CONSTRAINT "veiculos_proprietarioId_fkey" FOREIGN KEY ("proprietarioId") REFERENCES "proprietarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "locacoes" ADD CONSTRAINT "locacoes_veiculoId_fkey" FOREIGN KEY ("veiculoId") REFERENCES "veiculos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "locacoes" ADD CONSTRAINT "locacoes_motoristaid_fkey" FOREIGN KEY ("motoristaid") REFERENCES "motoristas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
