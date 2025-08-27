//
//  AppDependency.swift
//  BakeRoad
//
//  Created by 이현호 on 7/14/25.
//

import Foundation

final class AppDependency {
    static let shared = AppDependency()
    
    // MARK: - Network
    let tokenStore: TokenStore
    let authenticatedClient: APIClient
    let kakaoLoginService: KakaoLoginService
    
    // MARK: - Repositories
    let loginRepository: LoginRepository
    let verifyTokenRepository: VerifyTokenRepository
    let preferenceRepository: PreferenceRepository
    let userRepository: UserRepository
    let areasRepository: AreasRepository
    let bakeryRepository: BakeryRepository
    let tourRepository: TourRepository
    let reviewRepository: ReviewRepository
    let searchRepository: SearchRepository
    
    // MARK: - UseCases
    let loginUseCase: LoginUseCase
    let verifyTokenUseCase: VerifyTokenUseCase
    let getPreferenceOptionsUseCase: GetPreferenceOptionsUseCase
    let userOnboardUseCase: UserOnboardUseCase
    let getAreaListUseCase: GetAreaListUseCase
    let getBakeriesUseCase: GetBakeriesUseCase
    let getTourListUseCase: GetTourListUseCase
    let getBakeryListUseCase: GetBakeryListUseCase
    let getBakeryDetailUseCase: GetBakeryDetailUseCase
    let getBakeryReviewsUseCase: GetBakeryReviewsUseCase
    let getBakeryMyReviewsUseCase: GetBakeryMyReviewsUseCase
    let bakeryLikeUseCase: BakeryLikeUseCase
    let bakeryDislikeUseCase: BakeryDislikeUseCase
    let getBakeryReviewEligibilityUseCase: GetBakeryReviewEligibilityUseCase
    let writeReviewUseCase: WriteReviewUseCase
    let getBakeryMenuUseCase: GetBakeryMenuUseCase
    let reviewlikeUseCase: ReviewLikeUseCase
    let reviewDislikeUseCase: ReviewDislikeUseCase
    let getUserPreferenceUseCase: GetUserPreferenceUseCase
    let updateUserPreferenceUseCase: UpdateUserPreferenceUseCase
    let searchBakeyUseCase: SearchBakeryUseCase
    let getMyBakeryListUseCase: GetMyBakeryListUseCase
    let userProfileUseCase: UserProfileUseCase
    let userReviewUseCase: UserReviewUseCase
    let getBreadReportListUseCase: GetBreadReportListUseCase
    let getBreadReportUseCase: GetBreadReportUseCase
    
    private init() {
        // 네트워크/토큰 관련
        self.tokenStore = UserDefaultsTokenStore()
        let apiService = APIService.shared
        
        self.authenticatedClient = AuthenticatedAPIClientImpl(apiService: apiService, tokenStore: tokenStore)
        self.kakaoLoginService = KakaoLoginHelper()
        
        // Repository
        self.loginRepository = LoginRepositoryImpl(
            apiClient: authenticatedClient,
            kakaoLoginService: kakaoLoginService
        )
        self.verifyTokenRepository = VerifyTokenRepositoryImpl(
            apiClient: authenticatedClient
        )
        self.preferenceRepository = PreferenceRepositoryImpl(apiClient: authenticatedClient)
        self.userRepository = UserRepositoryImpl(apiClient: authenticatedClient)
        self.areasRepository = AreasRepositoryImpl(apiClient: authenticatedClient)
        self.bakeryRepository = BakeryRepositoryImpl(apiClient: authenticatedClient)
        self.tourRepository = TourRepositoryImpl(apiClient: authenticatedClient)
        self.reviewRepository = ReviewRepositoryImpl(apiClient: authenticatedClient)
        self.searchRepository = SearchRepositoryImpl(apiClient: authenticatedClient)
        
        // UseCase
        self.loginUseCase = LoginUseCaseImpl(repository: loginRepository)
        self.verifyTokenUseCase = VerifyTokenUseCaseImpl(repository: verifyTokenRepository)
        self.getPreferenceOptionsUseCase = GetPreferenceOptionsUseCaseImpl(repository: preferenceRepository)
        self.userOnboardUseCase = UserOnboardUseCaseImpl(repository: userRepository)
        self.getAreaListUseCase = GetAreaListUseCaseImpl(repository: areasRepository)
        self.getBakeriesUseCase = GetBakeriesUseCaseImpl(repository: bakeryRepository)
        self.getTourListUseCase = GetTourListUseCaseImpl(repository: tourRepository)
        self.getBakeryListUseCase = GetBakeryListUseCaseImpl(repository: bakeryRepository)
        self.getBakeryDetailUseCase = GetBakeryDetailUseCaseImpl(repository: bakeryRepository)
        self.getBakeryReviewsUseCase = GetBakeryReviewsUseCaseImpl(repository: bakeryRepository)
        self.getBakeryMyReviewsUseCase = GetBakeryMyReviewsUseCaseImpl(repository: bakeryRepository)
        self.bakeryLikeUseCase = BakeryLikeUseCaseImpl(repository: bakeryRepository)
        self.bakeryDislikeUseCase = BakeryDislikeUseCaseImpl(repository: bakeryRepository)
        self.getBakeryReviewEligibilityUseCase = GetBakeryReviewEligibilityUseCaseImpl(repository: bakeryRepository)
        self.writeReviewUseCase = WriteReviewUseCaseImpl(repository: bakeryRepository)
        self.getBakeryMenuUseCase = GetBakeryMenuUseCaseImpl(repository: bakeryRepository)
        self.reviewlikeUseCase = ReviewLikeUseCaseImpl(repository: reviewRepository)
        self.reviewDislikeUseCase = ReviewDislikeUseCaseImpl(repository: reviewRepository)
        self.getUserPreferenceUseCase = GetUserPreferenceUseCaseImpl(repository: userRepository)
        self.updateUserPreferenceUseCase = UpdateUserPreferenceUseCaseImpl(repository: userRepository)
        self.searchBakeyUseCase = SearchBakeryUseCaseImpl(repository: searchRepository)
        self.getMyBakeryListUseCase = GetMyBakeryListUseCaseImpl(repository: bakeryRepository)
        self.userProfileUseCase = UserProfileUseCaseImpl(repository: userRepository)
        self.userReviewUseCase = UserReviewUseCaseImpl(repository: userRepository)
        self.getBreadReportListUseCase = GetBreadReportListUseCaseImpl(repository: userRepository)
        self.getBreadReportUseCase = GetBreadReportUseCaseImpl(repository: userRepository)
    }
}
