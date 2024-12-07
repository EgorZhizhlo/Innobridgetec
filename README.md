# Innobridgetec
<a href="https://innobridgetecfond.tilda.ws/" style="display: inline-block; padding: 15px 30px; font-size: 18px; color: white; background-color: #007BFF; border: none; border-radius: 5px; text-decoration: none; transition: background-color 0.3s ease;">
        Перейти на сайт Innobridgetec
</a>

## Этот смарт-контракт предназначен для управления инвестициями через платформу A-Token. Он позволяет инвесторам вкладывать средства в определенные отрасли (агропромышленность, IT, экология, фармацевтика, энергетика) либо использовать единый токен, равномерно распределяющий средства между всеми сферами. Контракт поддерживает прозрачность и безопасное управление средствами.
### Ключевая задача контракта — поддерживать информацию о сферах, инвесторах и токенах.

#### Cтруктура для хранения данных о каждой сфере
```solidity
struct Sphere {
    string name;              // Название сферы
    address sphereToken;      // Адрес токена, связанного с этой сферой
    uint256 totalInvested;    // Общая сумма инвестиций
}

mapping(uint256 => Sphere) public spheres;  // Маппинг сфер по индексу
uint256 public sphereCount;                 // Количество сфер
address public owner;                       // Владелец контракта

mapping(address => mapping(uint256 => uint256)) public investorBalances;  // Балансы по сферам
mapping(address => uint256) public unifiedTokenBalances;                  // Баланс единого токена
```

#### Модификаторы и события

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can perform this action");
    _;
}
```
* Проверяет, что вызов сделан владельцем.

```solidity
event Investment(address indexed investor, uint256 indexed sphereIndex, uint256 amount);
event UnifiedInvestment(address indexed investor, uint256 amount);
event Withdrawal(address indexed investor, uint256 indexed sphereIndex, uint256 amount);
```
* Investment: Фиксирует инвестицию в конкретную сферу.
* UnifiedInvestment: Регистрирует вложения через единый токен.
* Withdrawal: Уведомляет о снятии средств.

#### Управления сферами
##### Добавление новой сферы:
```solidity
function addSphere(string memory name, address sphereToken) external onlyOwner {
    spheres[sphereCount] = Sphere(name, sphereToken, 0);
    sphereCount++;
}
```
* addSphere: Добавляет новую сферу с начальным балансом в 0.

#### Инициализация сфер
