import 'package:firebase_auth/firebase_auth.dart';

String mapAuthError(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'email-already-in-use' => 'Este email ja esta cadastrado.',
      'invalid-email' => 'Email invalido.',
      'invalid-credential' => 'Email ou senha invalidos.',
      'user-not-found' => 'Email ou senha invalidos.',
      'wrong-password' => 'Email ou senha invalidos.',
      'weak-password' => 'A senha informada e muito fraca.',
      'network-request-failed' => 'Falha de conexao. Verifique a internet.',
      'operation-not-allowed' =>
        'Login por email e senha ainda nao foi habilitado no Firebase.',
      _ => 'Nao foi possivel autenticar. Tente novamente.',
    };
  }

  return 'Nao foi possivel concluir a operacao. Tente novamente.';
}
