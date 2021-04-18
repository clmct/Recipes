import UIKit

// MARK: Layout
extension DetailRecipeViewController {
  
  func setupRecommended() {
    contentView.addSubview(recommendedTitleLabel)
    addChild(recipeRecommendedViewController)
    contentView.addSubview(recipeRecommendedViewController.view)
    recipeRecommendedViewController.didMove(toParent: self)
    
    recommendedTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionLabel.snp.bottom).offset(15)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    recipeRecommendedViewController.view.snp.makeConstraints { make in
      make.top.equalTo(recommendedTitleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalTo(contentView)
      make.height.equalTo(112)
    }

    contentView.snp.remakeConstraints { (make) in
      make.edges.width.equalToSuperview()
      make.bottom.equalTo(recipeRecommendedViewController.view.snp.bottom)
    }
    contentView.layoutIfNeeded()
    scrollView.layoutIfNeeded()
  }
  
  func setupDifficulty(difficulty: Int) {
    for i in 0..<5 {
      let difficultyImageView = UIImageView()
      contentView.addSubview(difficultyImageView)
      if i < difficulty {
        difficultyImageView.image = UIImage(named: "shape1")
      } else {
        difficultyImageView.image = UIImage(named: "shape0")
      }
      difficultyImageView.snp.makeConstraints { (make) in
        make.top.equalTo(difficultyTitleLabel.snp.bottom).offset(8)
        make.width.height.equalTo(20)
        make.leading.equalTo(40 * i + 24)
      }
    }
  }
  
  func setupPhotosScroll(count: Int) {
    for i in 0..<count {
      let imageView = UIImageView()
      
      if let images = viewModel?.recipe?.images,
        let url = URL(string: (images[i])) {
        imageView.kf.setImage(with: url)
      }
      imageView.contentMode = .scaleAspectFill
      let xPosition = photoScrollView.frame.width * CGFloat(i)
      imageView.frame = CGRect(x: xPosition, y: 0,
                               width: photoScrollView.frame.width,
                               height: photoScrollView.frame.height)
      
      photoScrollView.contentSize.width =  photoScrollView.frame.width * CGFloat(1 + i)
      photoScrollView.addSubview(imageView)
      pageControl.numberOfPages = count
    }
  }
  
  func sutupLayout() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(photoScrollView)
    contentView.addSubview(pageControl)
    contentView.addSubview(titleLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(difficultyTitleLabel)
    contentView.addSubview(instructionTitleLabel)
    contentView.addSubview(instructionLabel)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
    
    photoScrollView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(300)
    }
    
    pageControl.snp.makeConstraints { (make) in
      make.bottom.equalTo(photoScrollView)
      make.centerX.equalTo(contentView)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(photoScrollView.snp.bottom).offset(20)
      make.leading.equalTo(contentView).inset(20)
      make.trailing.equalTo(contentView).inset(70 + 24)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.bottom.equalTo(titleLabel)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    difficultyTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    instructionTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(difficultyTitleLabel.snp.bottom).offset(44)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    instructionLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionTitleLabel.snp.bottom).offset(8)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    contentView.snp.makeConstraints({ (make) in
      make.bottom.equalTo(instructionLabel.snp.bottom)
    })
  }
}
