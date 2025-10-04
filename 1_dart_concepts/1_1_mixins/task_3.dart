// Object equipable by a [Character].
abstract class Item {}

// Енам для разновидностей оружия, заранее предопределён
// Имеется тип [unknown] для неизвестного типа, является значением по умолчанию
enum WeaponTypes {
  sword,
  bow,
  katana,
  mace,
  dagger,
  spear,
  crossbow,
  axe,
  unknown,
}

// Енам для разновидностей брони, заранее предопределён
// Имеется тип [unknown] для неизвестного типа, является значением по умолчанию
enum ArmorTypes { helmet, chestplate, leggings, boots, unknown }

// Енам для слотов, чтобы упростить работу с [equip]
enum EquipmentSlot { leftHand, rightHand, hat, torso, legs, shoes }

// Миксин для предметов, которые могут наносить урон
mixin CanDamage {
  int get damage;

  List<EquipmentSlot> get slots;
}

// Миксин для предметов, которые могут защищать
mixin CanDefend {
  int get defense;

  EquipmentSlot get slot;
}

class Weapon extends Item with CanDamage {
  String name;
  WeaponTypes type;
  // Подразумеваем, что урон может изменяться, например, по уровню
  // (но не реализуем из-за ненадобности), поэтому оставляем не final
  int _damage;

  @override
  int get damage => _damage;

  @override
  List<EquipmentSlot> get slots {
    return [EquipmentSlot.rightHand, EquipmentSlot.leftHand];
  }

  Weapon({
    this.name = 'Unknown',
    this.type = WeaponTypes.unknown,
    required int damage,
  }) : _damage = damage;
}

class Armor extends Item with CanDefend {
  String name;
  ArmorTypes type;
  // Подразумеваем, что защита может изменяться, например, по уровню
  // (но не реализуем из-за ненадобности), поэтому оставляем не final
  int _defense;

  @override
  int get defense => _defense;

  @override
  EquipmentSlot get slot {
    switch (type) {
      case ArmorTypes.helmet:
        return EquipmentSlot.hat;
      case ArmorTypes.chestplate:
        return EquipmentSlot.torso;
      case ArmorTypes.leggings:
        return EquipmentSlot.legs;
      case ArmorTypes.boots:
        return EquipmentSlot.shoes;
      case ArmorTypes.unknown:
        throw UnknownArmorType();
    }
  }

  Armor({
    this.name = 'Unknown',
    this.type = ArmorTypes.unknown,
    required int defense,
  }) : _defense = defense;
}

/// Entity equipping [Item]s.
class Character {
  Item? leftHand;
  Item? rightHand;
  Item? hat;
  Item? torso;
  Item? legs;
  Item? shoes;

  /// Returns all the [Item]s equipped by this [Character].
  Iterable<Item> get equipped =>
      [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

  /// Returns the total damage of this [Character].
  int get damage {
    return equipped
        .whereType<CanDamage>()
        .map((CanDamage element) => element.damage)
        .fold(0, (int previousValue, int element) => previousValue + element);
  }

  /// Returns the total defense of this [Character].
  int get defense {
    return equipped
        .whereType<CanDefend>()
        .map((CanDefend element) => element.defense)
        .fold(0, (int previousValue, int element) => previousValue + element);
  }

  /// Equips the provided [item], meaning putting it to the corresponding slot.
  ///
  /// If there's already a slot occupied, then throws a [OverflowException].
  void equip(Item item) {
    if (item is Weapon) {
      bool isEquipped = false;
      for (final EquipmentSlot slot in item.slots) {
        if (isEquipped) {
          break;
        }
        switch (slot) {
          case EquipmentSlot.leftHand:
            if (leftHand == null) {
              leftHand = item;
              isEquipped = true;
            }
            break;
          case EquipmentSlot.rightHand:
            if (rightHand == null) {
              rightHand = item;
              isEquipped = true;
            }
            break;
          default:
            continue;
        }
      }
      if (!isEquipped) {
        throw OverflowException();
      }
    }
    if (item is Armor) {
      switch (item.slot) {
        case EquipmentSlot.hat:
          if (hat == null) {
            hat = item;
          } else {
            throw OverflowException();
          }
        case EquipmentSlot.torso:
          if (torso == null) {
            torso = item;
          } else {
            throw OverflowException();
          }
        case EquipmentSlot.legs:
          if (legs == null) {
            legs = item;
          } else {
            throw OverflowException();
          }
        case EquipmentSlot.shoes:
          if (shoes == null) {
            shoes = item;
          } else {
            throw OverflowException();
          }
        default:
          throw UnknownArmorType();
      }
    }
  }

  @override
  String toString() {
    return 'Защита персонажа — $defense, урон — $damage.';
  }
}

/// [Exception] indicating there's no place left in the [Character]'s slot.
class OverflowException implements Exception {}

class UnknownArmorType implements Exception {}

void main() {
  // Implement mixins to differentiate [Item]s into separate categories to be
  // equipped by a [Character]: weapons should have some damage property, while
  // armor should have some defense property.
  //
  // [Character] can equip weapons into hands, helmets onto hat, etc.

  Character vova = Character();
  Weapon sword = Weapon(
    damage: 10,
    type: WeaponTypes.sword,
    name: "Легендарный меч короля Артура",
  );
  Weapon bow = Weapon(
    damage: 100,
    type: WeaponTypes.bow,
    name: "Деревянный лук",
  );
  final Armor helmet = Armor(defense: 2, type: ArmorTypes.helmet);
  final Armor chestplate = Armor(defense: 5, type: ArmorTypes.chestplate);
  final Armor leggings = Armor(defense: 4, type: ArmorTypes.leggings);
  final Armor boots = Armor(defense: 2, type: ArmorTypes.boots);
  final Armor boots1 = Armor(defense: 3, type: ArmorTypes.boots);
  final Armor unknown = Armor(defense: 1);
  vova.equip(bow);
  vova.equip(sword);
  vova.equip(helmet);
  vova.equip(chestplate);
  vova.equip(leggings);
  vova.equip(boots);
  // vova.equip(boots1);
  // vova.equip(unknown);
  print(vova);
}
