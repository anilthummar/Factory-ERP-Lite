import '../../../service/network/response_handler.dart';
import '../entities/labor_entity.dart';

/// Contract for labor data access (domain layer only).
abstract class LaborRepository {
  Future<ResponseHandler<LaborEntity>> create(LaborEntity labor);

  Future<ResponseHandler<LaborEntity?>> getById(String id);

  Future<ResponseHandler<List<LaborEntity>>> getAll();

  Future<ResponseHandler<LaborEntity>> update(LaborEntity labor);

  Future<ResponseHandler<void>> delete(String id);

  Future<ResponseHandler<List<LaborEntity>>> search(String query);
}
