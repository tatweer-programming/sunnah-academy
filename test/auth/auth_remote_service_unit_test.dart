import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/apis/end_points.dart';
import 'package:sunnah_academy/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/auth_info.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';

import 'auth_remote_service_unit_test.mocks.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('AuthRemoteServices Tests', () {
    late AuthRemoteServices authRemoteServices;
    late MockDio mockDio;

    setUp(() {
      authRemoteServices = AuthRemoteServices();
      mockDio = MockDio();
      // Mock DioHelper static methods
      DioHelper.dio = mockDio;
    });

    group('register', () {
      test(
          'should return Right with Student and AuthInfo when registration succeeds',
          () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final mockResponse = Response(
          data: {
            'user': {
              'id': '1',
              'name': 'John Doe',
              'email': 'john@example.com',
            },
            'token': 'mock_token_123',
            'id': '1', // Add this for AuthInfo
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.register),
        );

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (success) {
            expect(success.value1, isA<Student>());
            expect(success.value2, isA<AuthInfo>());
            expect(success.value2.token, 'mock_token_123');
            expect(success.value2.id, '1');
          },
        );

        verify(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).called(1);
      });

      test('should return Left with AuthException when DioException occurs',
          () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: EndPoints.register),
          response: Response(
            statusCode: 400,
            data: {'error': 'Invalid data'},
            requestOptions: RequestOptions(path: EndPoints.register),
          ),
        );

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenThrow(dioException);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 400);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test(
          'should return Left with original exception when non-DioException occurs',
          () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final customException = Exception('Custom error');

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenThrow(customException);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, equals(customException));
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });

    group('login', () {
      test('should return Right with Student and AuthInfo when login succeeds',
          () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';

        final mockResponse = Response(
          data: {
            'user': {
              'id': '1',
              'name': 'John Doe',
              'email': email,
            },
            'token': 'login_token_123',
            'id': '1', // Add this for AuthInfo
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.login),
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (success) {
            expect(success.value1, isA<Student>());
            expect(success.value2, isA<AuthInfo>());
            expect(success.value2.token, 'login_token_123');
            expect(success.value2.id, '1');
          },
        );

        verify(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).called(1);
      });

      test(
          'should return Left with AuthException when login fails with DioException',
          () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'wrongpassword';

        final dioException = DioException(
          requestOptions: RequestOptions(path: EndPoints.login),
          response: Response(
            statusCode: 401,
            data: {'error': 'Invalid credentials'},
            requestOptions: RequestOptions(path: EndPoints.login),
          ),
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(dioException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 401);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test(
          'should return Left with original exception when non-DioException occurs during login',
          () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';
        final customException = Exception('Network error');

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(customException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, equals(customException));
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });

    group('forgotPassword', () {
      test('should return Right with Unit when forgot password succeeds',
          () async {
        // Arrange
        const email = 'john@example.com';

        final mockResponse = Response(
          data: {'message': 'Reset email sent'},
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.forgotPassword),
        );

        when(mockDio.post(
          EndPoints.forgotPassword,
          data: {
            'email': email,
          },
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.forgotPassword(email);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (success) {
            expect(success, equals(unit));
          },
        );

        verify(mockDio.post(
          EndPoints.forgotPassword,
          data: {
            'email': email,
          },
        )).called(1);
      });

      test(
          'should return Left with AuthException when forgot password fails with DioException',
          () async {
        // Arrange
        const email = 'notfound@example.com';

        final dioException = DioException(
          requestOptions: RequestOptions(path: EndPoints.forgotPassword),
          response: Response(
            statusCode: 404,
            data: {'error': 'User not found'},
            requestOptions: RequestOptions(path: EndPoints.forgotPassword),
          ),
        );

        when(mockDio.post(
          EndPoints.forgotPassword,
          data: {
            'email': email,
          },
        )).thenThrow(dioException);

        // Act
        final result = await authRemoteServices.forgotPassword(email);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 404);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test(
          'should return Left with original exception when non-DioException occurs during forgot password',
          () async {
        // Arrange
        const email = 'john@example.com';
        final customException = Exception('Server error');

        when(mockDio.post(
          EndPoints.forgotPassword,
          data: {
            'email': email,
          },
        )).thenThrow(customException);

        // Act
        final result = await authRemoteServices.forgotPassword(email);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, equals(customException));
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });

    group('resetPassword', () {
      test('should return Right with Unit when reset password succeeds',
          () async {
        // Arrange
        const newPassword = 'newPassword123';
        const oldPassword = 'oldPassword123';

        final mockResponse = Response(
          data: {'message': 'Password updated successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.resetPassword),
        );

        when(mockDio.post(
          EndPoints.resetPassword,
          data: {
            'newPassword': newPassword,
            'oldPassword': oldPassword,
          },
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result =
            await authRemoteServices.resetPassword(newPassword, oldPassword);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (success) {
            expect(success, equals(unit));
          },
        );

        verify(mockDio.post(
          EndPoints.resetPassword,
          data: {
            'newPassword': newPassword,
            'oldPassword': oldPassword,
          },
        )).called(1);
      });

      test(
          'should return Left with AuthException when reset password fails with DioException',
          () async {
        // Arrange
        const newPassword = 'newPassword123';
        const oldPassword = 'wrongOldPassword';

        final dioException = DioException(
          requestOptions: RequestOptions(path: EndPoints.resetPassword),
          response: Response(
            statusCode: 403,
            data: {'error': 'Invalid old password'},
            requestOptions: RequestOptions(path: EndPoints.resetPassword),
          ),
        );

        when(mockDio.post(
          EndPoints.resetPassword,
          data: {
            'newPassword': newPassword,
            'oldPassword': oldPassword,
          },
        )).thenThrow(dioException);

        // Act
        final result =
            await authRemoteServices.resetPassword(newPassword, oldPassword);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 403);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test(
          'should return Left with original exception when non-DioException occurs during reset password',
          () async {
        // Arrange
        const newPassword = 'newPassword123';
        const oldPassword = 'oldPassword123';
        final customException = Exception('Database error');

        when(mockDio.post(
          EndPoints.resetPassword,
          data: {
            'newPassword': newPassword,
            'oldPassword': oldPassword,
          },
        )).thenThrow(customException);

        // Act
        final result =
            await authRemoteServices.resetPassword(newPassword, oldPassword);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, equals(customException));
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });

    group('Edge Cases', () {
      test('should handle null response data in register', () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final mockResponse = Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.register),
        );

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            // Should throw an exception internally and be caught
            expect(failure, isA<Exception>());
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test('should handle empty email in login', () async {
        // Arrange
        const email = '';
        const password = 'password123';

        final mockResponse = Response(
          data: {
            'user': {
              'id': '1',
              'name': 'John Doe',
              'email': email,
            },
            'token': 'login_token_123',
            'id': '1',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.login),
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isRight(), true);
        verify(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).called(1);
      });

      test('should handle timeout exception', () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';

        final timeoutException = DioException(
          requestOptions: RequestOptions(path: EndPoints.login),
          type: DioExceptionType.connectionTimeout,
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(timeoutException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.requestOptions.path, EndPoints.login);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test('should handle malformed response data', () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final mockResponse = Response(
          data: {
            'invalid_structure': 'missing user and token fields',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: EndPoints.register),
        );

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<Exception>());
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test('should handle network errors', () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';

        final networkException = DioException(
          requestOptions: RequestOptions(path: EndPoints.login),
          type: DioExceptionType.connectionError,
          message: 'Network connection failed',
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(networkException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test('should handle server errors (500)', () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';

        final serverException = DioException(
          requestOptions: RequestOptions(path: EndPoints.login),
          response: Response(
            statusCode: 500,
            data: {'error': 'Internal server error'},
            requestOptions: RequestOptions(path: EndPoints.login),
          ),
        );

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(serverException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 500);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test('should handle rate limiting (429)', () async {
        // Arrange
        const email = 'john@example.com';

        final rateLimitException = DioException(
          requestOptions: RequestOptions(path: EndPoints.forgotPassword),
          response: Response(
            statusCode: 429,
            data: {'error': 'Too many requests'},
            requestOptions: RequestOptions(path: EndPoints.forgotPassword),
          ),
        );

        when(mockDio.post(
          EndPoints.forgotPassword,
          data: {
            'email': email,
          },
        )).thenThrow(rateLimitException);

        // Act
        final result = await authRemoteServices.forgotPassword(email);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.response?.statusCode, 429);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });

    // Test the exception classification indirectly
    group('Exception Classification', () {
      test(
          'should convert DioException to AuthException through register method',
          () async {
        // Arrange
        final creationForm = StudentCreationForm(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phoneNumber: '1234567890',
          birthDate: '1990-01-01',
          gender: 'male',
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: EndPoints.register),
          response: Response(
            statusCode: 400,
            data: {'error': 'Bad request'},
            requestOptions: RequestOptions(path: EndPoints.register),
          ),
        );

        when(mockDio.post(
          EndPoints.register,
          data: creationForm.toJson(),
        )).thenThrow(dioException);

        // Act
        final result = await authRemoteServices.register(creationForm);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthException>());
            final authException = failure as AuthException;
            expect(authException.requestOptions.path, EndPoints.register);
            expect(authException.response?.statusCode, 400);
          },
          (success) => fail('Expected Left but got Right'),
        );
      });

      test(
          'should return original exception when not DioException through login method',
          () async {
        // Arrange
        const email = 'john@example.com';
        const password = 'password123';
        final customException = Exception('Custom error');

        when(mockDio.post(
          EndPoints.login,
          data: {
            'email': email,
            'password': password,
          },
        )).thenThrow(customException);

        // Act
        final result = await authRemoteServices.login(email, password);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, equals(customException));
            expect(failure, isNot(isA<AuthException>()));
          },
          (success) => fail('Expected Left but got Right'),
        );
      });
    });
  });
}
