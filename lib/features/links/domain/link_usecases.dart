import 'link_entity.dart';
import 'link_repository.dart';

/// Use case for adding a new link
class AddLinkUseCase {
  final LinkRepository _repository;

  AddLinkUseCase(this._repository);

  Future<void> call(LinkEntity link) async {
    await _repository.addLink(link);
  }
}

/// Use case for getting all links
class GetAllLinksUseCase {
  final LinkRepository _repository;

  GetAllLinksUseCase(this._repository);

  Future<List<LinkEntity>> call() async {
    return await _repository.getAllLinks();
  }
}

/// Use case for searching links
class SearchLinksUseCase {
  final LinkRepository _repository;

  SearchLinksUseCase(this._repository);

  Future<List<LinkEntity>> call(String query) async {
    return await _repository.searchLinks(query);
  }
}

/// Use case for deleting a link
class DeleteLinkUseCase {
  final LinkRepository _repository;

  DeleteLinkUseCase(this._repository);

  Future<void> call(String linkId) async {
    await _repository.deleteLink(linkId);
  }
}
