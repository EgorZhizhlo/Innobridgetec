# Innobridgetec
<div style="text-align: center; margin: 20px 0;">
    <a href="https://innobridgetecfond.tilda.ws/" style="display: inline-block; padding: 15px 30px; font-size: 18px; color: white; background-color: #007BFF; border: none; border-radius: 5px; text-decoration: none; transition: background-color 0.3s ease;">
        Перейти на сайт Innobridgetec
    </a>
</div>

## Этот смарт-контракт предназначен для управления инвестициями через платформу A-Token. Он позволяет инвесторам вкладывать средства в определенные отрасли (агропромышленность, IT, экология, фармацевтика, энергетика) либо использовать единый токен, равномерно распределяющий средства между всеми сферами. Контракт поддерживает прозрачность и безопасное управление средствами.
### Ключевая задача контракта — поддерживать информацию о сферах, инвесторах и токенах.
#### Cтруктура для хранения данных о каждой сфере
```solidity
struct Sphere {
    string name; # Название сферы
    address sphereToken; # Адрес токена, представляющего эту сферу
    uint256 totalInvested; # Общая сумма вложений в сферу
}
Sphere[] public spheres; # Массив всех сфер
address public owner; # Владелец контракта, который может обновлять данные (например, токены сфер)
```
#### Инициализация сфер
