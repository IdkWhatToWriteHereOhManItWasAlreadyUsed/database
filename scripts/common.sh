#!/bin/bash
# Общие переменные и функции для всех скриптов

# Определяем корень проекта (директория, где находится этот файл)
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export TOOLS_DIR="$PROJECT_ROOT/tools/liquibase"
export CONFIG_DIR="$PROJECT_ROOT/config/database"
export MIGRATIONS_DIR="$PROJECT_ROOT/migrations"
export SCRIPTS_DIR="$PROJECT_ROOT/scripts"
export LOG_DIR="$PROJECT_ROOT/logs"

# Цвета для вывода
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

# Функции для логирования
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Функция для загрузки конфигурации окружения
load_env_config() {
    local env=${1:-dev}
    local config_file="$CONFIG_DIR/$env.properties"
    
    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    source "$config_file"
    export DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD
    log_info "Loaded configuration for environment: $env"
    return 0
}

# Функция для проверки наличия Liquibase
check_liquibase() {
    if [ ! -f "$TOOLS_DIR/liquibase" ]; then
        log_error "Liquibase not found! Please run install.sh first."
        return 1
    fi
    return 0
}