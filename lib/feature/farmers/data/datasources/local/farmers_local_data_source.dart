import '../../../../../core/data/database/app_database.dart';
import '../../../../../core/errors/exceptions.dart';
import 'entity/farmer_entity.dart';

abstract class FarmersLocalDataSource {
  Future<List<FarmerEntity>> getAllFarmers();
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo);
  Future<List<FarmerEntity>> getRouteFarmers(int collectorId);
  Future<void> deleteAllFarmers();
  Future<void> insertFarmer(List<FarmerEntity> farmer);
}

class FarmersLocalDataSourceImpl implements FarmersLocalDataSource {
  final JufredsDatabase database;
  FarmersLocalDataSourceImpl(this.database);

  @override
  Future<void> deleteAllFarmers() async {
    try {
      final dao = database.farmersDao;
      await dao.deleteAllFarmers();
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo) async {
    try {
      final dao = database.farmersDao;
      final farmer = await dao.getFarmerByFarmerNo(farmerNo);
      return farmer;
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<FarmerEntity>> getAllFarmers() async {
    try {
      final dao = database.farmersDao;
      final farmers = await dao.getAllFarmers();
      farmers.sort((a, b) => b.farmerNo.compareTo(a.farmerNo));
      return farmers;
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<void> insertFarmer(List<FarmerEntity> farmer) async {
    try {
      final dao = database.farmersDao;
      dao.insertFarmers(farmer);
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<FarmerEntity>> getRouteFarmers(int collectorId) {
    return getAllFarmers();
  }
}
