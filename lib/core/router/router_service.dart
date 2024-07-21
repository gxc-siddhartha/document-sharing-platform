import 'package:document_sharing_app/documents/screens/document_screen.dart';
import 'package:document_sharing_app/features/divisions/screens/division_screen.dart';
import 'package:document_sharing_app/features/home/screens/home_screen.dart';
import 'package:document_sharing_app/features/initial/screens/initial_screen.dart';
import 'package:document_sharing_app/features/subjects/screens/subject_screen.dart';
import 'package:document_sharing_app/features/university/screens/add_university_screen.dart';
import 'package:document_sharing_app/features/university/screens/university_selection_screen.dart';
import 'package:go_router/go_router.dart';

class RouterService {
  static GoRouter loggedOutRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: RouterConstants.initialScreenRouteName,
        builder: (context, state) {
          return InitialScreen();
        },
      ),
    ],
  );

  static GoRouter loggedInRoute = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: RouterConstants.homeScreenRouteName,
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: 'select-university-screen',
            name: RouterConstants.selectUniversityRouteName,
            builder: (context, state) {
              return const UniversitySelectionScreen();
            },
            routes: [
              GoRoute(
                path: 'add-university-screen',
                name: RouterConstants.addUniversityRouteName,
                builder: (context, state) {
                  return const AddUniversityScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: 'division-screen/:universityId/:courseId',
            name: RouterConstants.divisionScreenRouteName,
            builder: (context, state) {
              return DivisionScreen(
                universityId: state.pathParameters['universityId']!,
                courseId: state.pathParameters['courseId']!,
              );
            },
            routes: [
              GoRoute(
                  path: 'subject-screen/:divisionId',
                  name: RouterConstants.subjectScreenRouteName,
                  builder: (context, state) {
                    final universityId = state.pathParameters['universityId']!;
                    final courseId = state.pathParameters['courseId']!;
                    return SubjectScreen(
                      universityId: universityId,
                      courseId: courseId,
                      divisionId: state.pathParameters['divisionId']!,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'document-screen/:subjectId',
                      name: RouterConstants.documentScreenRouteName,
                      builder: (context, state) {
                        final universityId =
                            state.pathParameters['universityId']!;
                        final courseId = state.pathParameters['courseId']!;
                        final divisionId = state.pathParameters['divisionId']!;
                        final subjectId = state.pathParameters['subjectId']!;
                        return DocumentScreen(
                          universityId: universityId,
                          courseId: courseId,
                          divisionId: divisionId,
                          subjectId: subjectId,
                        );
                      },
                    )
                  ]),
            ],
          ),
        ],
      ),
    ],
  );
}

class RouterConstants {
  static const initialScreenRouteName = "initialScreenRouteName";
  static const selectUniversityRouteName = "selectUniversityRouteName";
  static const addUniversityRouteName = "addUniversityRouteName";
  static const loginScreenRouteName = "loginScreenRouteName";
  static const homeScreenRouteName = "homeScreenRouteName";
  static const divisionScreenRouteName = "divisionScreenRouteName";
  static const subjectScreenRouteName = "subjectScreenRouteName";

  static const documentScreenRouteName = "documentScreenRouteName";
}
