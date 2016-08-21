SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS `Location`;
DROP TABLE IF EXISTS `Device`;
DROP TABLE IF EXISTS `DataType`;
DROP TABLE IF EXISTS `DataField`;
DROP TABLE IF EXISTS `DataRecord`;
DROP TABLE IF EXISTS `RecordFieldValue`;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `User` (
    `Id` VARCHAR(50) NOT NULL,
    `Password` VARCHAR(30) NOT NULL,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`Id`),
    UNIQUE (`Id`)
);

CREATE TABLE `Location` (
    `Id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(20) NOT NULL,
    `Description` VARCHAR(50) NOT NULL,
    `UserRef` VARCHAR(50) NOT NULL,
    `Parent` INTEGER UNSIGNED,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`Id`)
);
ALTER TABLE `Location` ADD FOREIGN KEY (`UserRef`) REFERENCES `User`(`Id`);
ALTER TABLE `Location` ADD FOREIGN KEY (`Parent`) REFERENCES `Location`(`Id`);

CREATE TABLE `Device` (
    `Id` INTEGER UNSIGNED NOT NULL,
    `Name` VARCHAR(20) NOT NULL,
    `Description` VARCHAR(50) NOT NULL,
    `OwnerRef` VARCHAR(30) NOT NULL,
    `LocationRef` INTEGER UNSIGNED,
    `Parent` INTEGER UNSIGNED,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`Id`)
);
ALTER TABLE `Device` ADD FOREIGN KEY (`LocationRef`) REFERENCES `Location`(`Id`);
ALTER TABLE `Device` ADD FOREIGN KEY (`OwnerRef`) REFERENCES `User`(`Id`);
ALTER TABLE `Device` ADD FOREIGN KEY (`Parent`) REFERENCES `Device`(`Id`);

CREATE TABLE `DataType` (
    `TypeName` VARCHAR(8) NOT NULL,
    `Description` VARCHAR(50) NOT NULL,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`TypeName`)
);

CREATE TABLE `DataField` (
    `DeviceRef` INTEGER UNSIGNED NOT NULL,
    `DatafieldName` VARCHAR(10) NOT NULL,
    `Controllable` BOOLEAN NOT NULL DEFAULT false,
    `DataTypeRef` VARCHAR(8) NOT NULL,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`DeviceRef`, `DatafieldName`)
);
ALTER TABLE `DataField` ADD FOREIGN KEY (`DeviceRef`) REFERENCES `Device`(`Id`);
ALTER TABLE `DataField` ADD FOREIGN KEY (`DataTypeRef`) REFERENCES `DataType`(`TypeName`);

CREATE TABLE `DataRecord` (
    `Idx` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `DeviceRef` INTEGER UNSIGNED NOT NULL,
    `LocationRef` INTEGER UNSIGNED,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`Idx`)
);
ALTER TABLE `DataRecord` ADD FOREIGN KEY (`LocationRef`) REFERENCES `Location`(`Id`);
ALTER TABLE `DataRecord` ADD FOREIGN KEY (`DeviceRef`) REFERENCES `Device`(`Id`);

CREATE TABLE `RecordFieldValue` (
    `Idx` INTEGER NOT NULL AUTO_INCREMENT,
    `RecordRef` INTEGER UNSIGNED NOT NULL,
    `DeviceRef` INTEGER UNSIGNED NOT NULL,
    `DataFieldNameRef` VARCHAR(10) NOT NULL,
    `Value` VARCHAR(50) NOT NULL,
    `CreatedTime` DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`Idx`)
);
ALTER TABLE `RecordFieldValue` ADD FOREIGN KEY (`DeviceRef`, `DataFieldNameRef`) REFERENCES `DataField`(`DeviceRef`,`DatafieldName`);
ALTER TABLE `RecordFieldValue` ADD FOREIGN KEY (`RecordRef`) REFERENCES `DataRecord`(`Idx`);
