CREATE TABLE Passengers (
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(80) NOT NULL
);

CREATE TABLE Towns (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL
);

CREATE TABLE RailwayStations (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    TownId INT NOT NULL,
    FOREIGN KEY (TownId) REFERENCES Towns(Id)
);

CREATE TABLE Trains (
    Id INT PRIMARY KEY IDENTITY,
    HourOfDeparture VARCHAR(5) NOT NULL,
    HourOfArrival VARCHAR(5) NOT NULL,
    DepartureTownId INT NOT NULL,
    ArrivalTownId INT NOT NULL,
    FOREIGN KEY (DepartureTownId) REFERENCES Towns(Id),
    FOREIGN KEY (ArrivalTownId) REFERENCES Towns(Id)
);

CREATE TABLE TrainsRailwayStations (
    TrainId INT NOT NULL,
    RailwayStationId INT NOT NULL,
    CONSTRAINT PK_TrainsRailwayStations PRIMARY KEY (TrainId, RailwayStationId),
    CONSTRAINT FK_TrainsRailwayStations_Trains FOREIGN KEY (TrainId) REFERENCES Trains(Id),
    CONSTRAINT FK_TrainsRailwayStations_RailwayStations FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)
);

CREATE TABLE MaintenanceRecords (
    Id INT PRIMARY KEY IDENTITY,
    DateOfMaintenance DATE NOT NULL,
    Details VARCHAR(2000) NOT NULL,
    TrainId INT NOT NULL,
    FOREIGN KEY (TrainId) REFERENCES Trains(Id)
);

CREATE TABLE Tickets (
    Id INT PRIMARY KEY IDENTITY,
    Price DECIMAL(18, 2) NOT NULL,
    DateOfDeparture DATE NOT NULL,
    DateOfArrival DATE NOT NULL,
    TrainId INT NOT NULL,
    PassengerId INT NOT NULL,
    FOREIGN KEY (TrainId) REFERENCES Trains(Id),
    FOREIGN KEY (PassengerId) REFERENCES Passengers(Id)
);