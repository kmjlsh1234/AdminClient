// 📦 Package imports:
import 'dart:developer';
import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_list/drop_out_users_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_currency_view.dart';
import 'package:acnoo_flutter_admin_panel/app/providers/admin/admin_provider.dart';
import 'package:acnoo_flutter_admin_panel/app/services/admin/jwt_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../models/admin/admin.dart';
import '../models/admin_user/admin_user_detail.dart';
import '../pages/admin_page/admin_list/admins_list_view.dart';
import '../pages/pages.dart';
import '../pages/users_page/user_profile/user_currency_rocord_view.dart';
import '../providers/providers.dart';
import '../services/admin/admin_service.dart';

abstract class AcnooAppRoutes {
  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _emailShellNavigatorKey = GlobalKey<NavigatorState>();
  //--------------Navigator Keys--------------//

  static const _initialPath = '/';

  static final routerConfig = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: _initialPath,
    routes: [
      // Landing Route Handler
      GoRoute(
        path: _initialPath,
        redirect: (context, state) async {
          final _appLangProvider = Provider.of<AppLanguageProvider>(context);

          if (state.uri.queryParameters['rtl'] == 'true') {
            _appLangProvider.isRTL = true;
          }

          final JwtService jwtService = JwtService();
          final AdminService adminService = AdminService();
          final AdminProvider adminProvider = Provider.of<AdminProvider>(context, listen: false);
          log('APP_ROUTE_START');
          try{
            String? jwt = window.localStorage['jwt'];
            if(jwt!=null){
              log('REDIRECT');
              bool isSuccess = await jwtService.tokenCheck();
              if(isSuccess){
                Admin admin = await adminService.getAdmin();
                if(admin != null){
                  adminProvider.setAdmin(admin);
                  return '/dashboard/ecommerce-admin';
                }
              }
            }
          } on DioError catch (e){
            log(e.toString());
          }
          return '/authentication/signin';
        },
      ),

      // Global Shell Route
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: ShellRouteWrapper(child: child),
          );
        },
        routes: [
          // Dashboard Routes
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard') {
                return '/dashboard/ecommerce-admin';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ecommerce-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ECommerceAdminDashboardView(),
                ),
              ),
              GoRoute(
                path: 'open-ai-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: OpenAIDashboardView(),
                ),
              ),
              GoRoute(
                path: 'erp-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ERPAdminDashboardView(),
                ),
              ),
              GoRoute(
                path: 'pos-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'earning-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: RewardEarningAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'sms-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SMSAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'influencer-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: InfluencerAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'hrm-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: HRMAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'news-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NewsAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'store-analytics',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: StoreAnalyticsDashboard(),
                ),
              ),
            ],
          ),

          // Widgets Routes
          GoRoute(
            path: '/widgets',
            redirect: (context, state) async {
              if (state.fullPath == '/widgets') {
                return '/widgets/general-widgets';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'general-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GeneralWidgetsView(),
                ),
              ),
              GoRoute(
                path: 'chart-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ChartWidgetsView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: CalendarView(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ChatView(),
            ),
          ),

          // Email Shell Routes
          GoRoute(
            path: '/email',
            redirect: (context, state) async {
              if (state.fullPath == '/email') {
                return '/email/inbox';
              }
              return null;
            },
            routes: [
              ShellRoute(
                navigatorKey: _emailShellNavigatorKey,
                pageBuilder: (context, state, child) {
                  return NoTransitionPage(
                    child: EmailView(child: child),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'inbox',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailInboxView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'starred',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailStarredView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'sent',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSentView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'drafts',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDraftsView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'spam',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSpamView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'trash',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailTrashView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':folder/details',
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDetailsView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProjectsView(),
            ),
          ),
          GoRoute(
            path: '/kanban',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: KanbanView(),
            ),
          ),

          // E-Commerce Routes
          GoRoute(
            path: '/ecommerce',
            redirect: (context, state) async {
              if (state.fullPath == '/ecommerce') {
                return '/ecommerce/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "product-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductListView(),
                ),
              ),
              GoRoute(
                path: "product-details",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductDetailsView(),
                ),
              ),
              GoRoute(
                path: "cart",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CartView(),
                ),
              ),
              GoRoute(
                path: "checkout",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CheckoutView(),
                ),
              ),
            ],
          ),

          // POS Inventory Routes
          GoRoute(
            path: '/pos-inventory',
            redirect: (context, state) async {
              if (state.fullPath == '/pos-inventory') {
                return '/pos-inventory/sale';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "sale",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleView(),
                ),
              ),
              GoRoute(
                path: "sale-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleListView(),
                ),
              ),
              GoRoute(
                path: "purchase",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseView(),
                ),
              ),
              GoRoute(
                path: "purchase-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseListView(),
                ),
              ),
              GoRoute(
                path: "product",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSProductView(),
                ),
              ),
            ],
          ),

          // Open AI Routes
          GoRoute(
            path: '/open-ai',
            redirect: (context, state) async {
              if (state.fullPath == '/open-ai') {
                return '/open-ai/ai-writter';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ai-writter',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiWriterView(),
                ),
              ),
              GoRoute(
                path: 'ai-image',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiImageView(),
                ),
              ),
              StatefulShellRoute.indexedStack(
                pageBuilder: (context, state, page) {
                  AIChatPageListener.initialize(page);
                  return NoTransitionPage(
                    child: AiChatView(page: page),
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'ai-chat',
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: AIChatDetailsView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'ai-code',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiCodeView(),
                ),
              ),
              GoRoute(
                path: 'ai-voiceover',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiVoiceoverView(),
                ),
              ),
            ],
          ),
          // Admin Route
          GoRoute(
            path: '/admins',
            redirect: (context, state) async {
              if (state.fullPath == '/admins') {
                return '/admins/admin-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'admin-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AdminsListView(),
                ),
              ),
              GoRoute(
                path: 'admin-grid',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersGridView(),
                ),
              ),
              GoRoute(
                path: 'admin-profile',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersGridView(),//UserProfileView(),
                ),
              ),
            ],
          ),
          // Users Route
          GoRoute(
            path: '/users',
            redirect: (context, state) async {
              if (state.fullPath == '/users') {
                return '/users/user-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersListView(),
                ),
              ),
              GoRoute(
                path: 'drop-out-user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DropOutUsersListView(),
                ),
              ),
              GoRoute(
                path: 'black-user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersGridView(),
                ),
              ),
              GoRoute(
                path: 'profile/:id',
                pageBuilder: (context, state) {
                  final String idString = state.pathParameters['id']!;
                  final int userId = int.parse(idString);
                  return NoTransitionPage<void>(
                    child: UserProfileView(userId: userId),
                  );
                },
              ),
              GoRoute(
                path: 'currency/:id',
                pageBuilder: (context, state) {
                  final String idString = state.pathParameters['id']!;
                  final int userId = int.parse(idString);
                  return NoTransitionPage<void>(
                    child: UserCurrencyView(userId: userId),
                  );
                },
              ),
              GoRoute(
                path: 'currency/record/:id',
                pageBuilder: (context, state) {
                  final String idString = state.pathParameters['id']!;
                  final int userId = int.parse(idString);
                  return NoTransitionPage<void>(
                    child: UserCurrencyRecordView(userId: userId),
                  );
                },
              ),
            ],
          ),

          //--------------Application Section--------------//

          //--------------Tables & Forms--------------//
          GoRoute(
            path: '/tables',
            redirect: (context, state) async {
              if (state.fullPath == '/tables') {
                return '/tables/basic-table';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicTableView(),
                ),
              ),
              GoRoute(
                path: 'data-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DataTableView(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: '/forms',
            redirect: (context, state) async {
              if (state.fullPath == '/forms') {
                return '/forms/basic-forms';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-forms',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicFormsView(),
                ),
              ),
              GoRoute(
                path: 'form-select',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormSelectView(),
                ),
              ),
              GoRoute(
                path: 'form-validation',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormValidationView(),
                ),
              ),
            ],
          ),
          //--------------Tables & Forms--------------//

          //--------------Components--------------//
          GoRoute(
            path: '/components',
            redirect: (context, state) async {
              if (state.fullPath == '/components') {
                return '/components/buttons';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'buttons',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ButtonsView(),
                ),
              ),
              GoRoute(
                path: 'colors',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ColorsView(),
                ),
              ),
              GoRoute(
                path: 'alerts',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AlertsView(),
                ),
              ),
              GoRoute(
                path: 'typography',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TypographyView(),
                ),
              ),
              GoRoute(
                path: 'cards',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: CardsView(),
                ),
              ),
              GoRoute(
                path: 'avatars',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AvatarsView(),
                ),
              ),
              GoRoute(
                path: 'dragndrop',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DragAndDropView(),
                ),
              ),
            ],
          ),
          //--------------Components--------------//

          //--------------Pages--------------//
          GoRoute(
            path: '/pages',
            redirect: (context, state) async {
              if (state.fullPath == '/pages') {
                return '/pages/gallery';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'gallery',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GalleryView(),
                ),
              ),
              GoRoute(
                path: 'maps',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: MapsView(),
                ),
              ),
              GoRoute(
                path: 'pricing',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PricingView(),
                ),
              ),
              GoRoute(
                path: 'tabs-and-pills',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TabsNPillsView(),
                ),
              ),
              GoRoute(
                path: '404',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NotFoundView(),
                ),
              ),
              GoRoute(
                path: 'faqs',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FaqView(),
                ),
              ),
              GoRoute(
                path: 'privacy-policy',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PrivacyPolicyView(),
                ),
              ),
              GoRoute(
                path: 'terms-conditions',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TermsConditionView(),
                ),
              ),
            ],
          ),
          //--------------Pages--------------//
        ],
      ),

      // Full Screen Pages
      GoRoute(
        path: '/authentication/signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupView(),
        ),
      ),
      GoRoute(
        path: '/authentication/signin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninView(),
        ),
      )
    ],

    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}
