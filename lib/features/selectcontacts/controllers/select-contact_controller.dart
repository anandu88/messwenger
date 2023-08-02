import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/features/selectcontacts/respirotory/select_contact_repo.dart';

final getContactsProvider=FutureProvider((ref){
final selectContactRepository=ref.watch(selectContactsRepositoryProvider);
return selectContactRepository.getContacts();
});
final selectcontactcontrollerProvider=Provider((ref) {
final  selectContactRepository=ref.watch(selectContactsRepositoryProvider);
return Selectcontactcontroller(ref: ref, selectContactRepository: selectContactRepository);
});

class Selectcontactcontroller {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  Selectcontactcontroller({required this.ref, required this.selectContactRepository});
  void selectContact(Contact selectedcontact, BuildContext context){
    selectContactRepository.selectcontact(selectedcontact, context);
  }
  
}