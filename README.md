# Смарт-контракт ЦФА от <a href="https://innobridgetecfond.tilda.ws/" style="display: inline-block; padding: 15px 30px; font-size: 18px; color: white; background-color: #007BFF; border: none; border-radius: 5px; text-decoration: none; transition: background-color 0.3s ease;">Innobridgetec</a>
## Описание смарт-контракта

Наш контракт создан для управления средствами инвесторов в шести ключевых направлениях:
- **Агропромышленность**
- **IT**
- **Экология**
- **Фармацевтика**
- **Энергетика**
- **Единый токен** (распределяет средства равномерно между направлениями).

Мы сделали контракт безопасным, гибким и готовым к масштабируемой интеграции с внешними приложениями.

---

## 1. Учет активов

Контракт структурирован для отслеживания инвестиций в разные сферы. Каждая сфера имеет:
- **Уникальное имя** для идентификации.
- **Привязанный токен** для учета долей участия.
- **Общий объем инвестиций**, отражающий вложенные средства.

```solidity
struct Sphere {
    string name;
    address sphereToken;
    uint256 totalInvested;
}
```

---

## 2. Инвестиции через единый токен

Единый токен упрощает распределение средств по сферам. Инвесторы вносят средства, а контракт автоматически распределяет их.

```solidity
function investWithUnifiedToken(uint256[] memory amounts) external payable {
    require(amounts.length == sphereCount, "Invalid input data");

    uint256 totalAmount = 0;
    for (uint256 i = 0; i < sphereCount; i++) {
        require(amounts[i] > 0, "Investment amount must be greater than zero");
        spheres[i].totalInvested += amounts[i];
        investorBalances[msg.sender][i] += amounts[i];
        totalAmount += amounts[i];
    }
    require(msg.value == totalAmount, "Insufficient funds");

    unifiedTokenBalances[msg.sender] += totalAmount;
    emit UnifiedInvestment(msg.sender, totalAmount);
}
```

---

## 3. Прозрачность и контроль

Мы реализовали функции для полного контроля инвесторами и регуляторами:
- **Учет балансов инвесторов по сферам.**
- **Инструменты мониторинга долей.**

```solidity
function getInvestorBalances(address investor) external view returns (uint256[] memory) {
    uint256[] memory balances = new uint256[](sphereCount);
    for (uint256 i = 0; i < sphereCount; i++) {
        balances[i] = investorBalances[investor][i];
    }
    return balances;
}
```

---

## 4. Безопасность и защита

Мы используем лучшие практики для защиты средств:
- Предотвращение атак повторного входа.
- Безопасный вывод средств с обработкой ошибок.

```solidity
function withdrawFromSphere(uint256 sphereIndex, uint256 amount) external {
    require(sphereIndex < sphereCount, "Invalid sphere index");
    require(!inWithdrawal[msg.sender], "Reentrant call detected");
    require(investorBalances[msg.sender][sphereIndex] >= amount, "Insufficient balance");

    inWithdrawal[msg.sender] = true;

    investorBalances[msg.sender][sphereIndex] -= amount;
    spheres[sphereIndex].totalInvested -= amount;

    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require(success, "Transfer failed");

    inWithdrawal[msg.sender] = false;
    emit Withdrawal(msg.sender, sphereIndex, amount);
}
```

---

## 5. Гибкость и масштабируемость

Бизнес-цели и требования меняются. Поэтому:
- Сферы инвестирования можно добавлять и изменять.
- Токены привязанных активов можно обновлять.

```solidity
function addSphere(string memory name, address sphereToken) external onlyOwner {
    require(sphereCount < MAX_SPHERES, "Maximum spheres limit reached");
    spheres[sphereCount] = Sphere(name, sphereToken, 0);
    sphereCount++;
}
```

---

## 6. Интеграция с внешними приложениями

Контракт полностью готов к взаимодействию с внешними приложениями и платформами. Реализовано это было с помощью: 

### 6.1. События для мониторинга

Все ключевые операции генерируют события (`event`), которые могут быть использованы сторонними приложениями для:
- Отслеживания транзакций в реальном времени.
- Формирования отчетов для инвесторов и регуляторов.

Пример события:
```solidity
event InvestmentMade(address indexed investor, uint256 sphereIndex, uint256 amount);
event UnifiedInvestment(address indexed investor, uint256 totalAmount);
```

### 6.2. Прозрачные API-функции

Контракт предоставляет `view`-функции, которые позволяют:
- Получать данные об инвестициях конкретного пользователя.
- Просматривать общую информацию о каждой сфере.

Это позволяет легко интегрировать смарт-контракт с:
- **dApps**, отображающими интерфейс для инвесторов.
- Аналитическими инструментами для визуализации данных.
- ERP-системами для учета и отчетности.

Пример:
```solidity
function getSphere(uint256 index) external view returns (string memory, address, uint256) {
    require(index < sphereCount, "Invalid index");
    Sphere memory sphere = spheres[index];
    return (sphere.name, sphere.sphereToken, sphere.totalInvested);
}
```

### 6.3. Интеграция с платежными шлюзами

Смарт-контракт поддерживает прием ETH, что позволяет интегрировать его с криптоплатежными сервисами. Также предусмотрена возможность дополнения с использованием токенов стандарта ERC20.

### 6.4. Web3-интеграция

Контракт совместим с Web3-библиотеками, что позволяет легко подключить его к пользовательским интерфейсам и обеспечить доступ к функциям:
- Инвестирования.
- Вывода средств.
- Мониторинга.

---

## Контракт от Innobridgetec: Ваша уверенность в инвестициях

С нашим контрактом вы получите:
- **Безопасность средств.**
- **Прозрачность инвестиций.**
- **Гибкость настроек.**
