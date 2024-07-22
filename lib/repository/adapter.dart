abstract class Adapter<T> {
  Future<void> createObject(T collection);

  Future<void> createMultipleObjects(List<T> collections);

  Future getObjectByID(int id);

  Future<List> getMultipleObjectsByIDs(List<int> ids);

  Future<List> getAllObjects();

  Future<void> updateObject(T collection);

  Future<void> deleteObject(T collection);

  Future<void> deleteMultipleObjects(List<int> ids);
}
