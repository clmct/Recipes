import UIKit

final class InformationViewComponent: UIView {
  
  // MARK: Properties
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let difficultyTitleLabel = UILabel()
  private let instructionTitleLabel = UILabel()
  private let instructionLabel = UILabel()
  private let dateLabel = UILabel()
  
  // MARK: Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal Methods
  func configure(recipe: RecipeElement) {
    difficultyTitleLabel.text = "Difficulty:"
    instructionLabel.text = "Instruction:"
    titleLabel.text = recipe.name
    descriptionLabel.text = recipe.description
    instructionLabel.text = recipe.instructions.replacingOccurrences(of: "<br>", with: "\n", options: .literal, range: nil)
    dateLabel.text = self.getDate(data: recipe.lastUpdated)
    setupDifficulty(difficulty: recipe.difficulty)
  }
  
  // MARK: Private Methods
  private func getDate(data: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(data))
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
  }
  
  private func createLabel(textColor: UIColor, font: UIFont, numberOfLines: Int) -> UILabel {
    let label = UILabel()
    label.textColor = textColor
    label.font = font
    label.numberOfLines = numberOfLines
    return label
  }
  
  private func setupDifficulty(difficulty: Int) {
    for i in 0..<5 {
      let difficultyImageView = UIImageView()
      addSubview(difficultyImageView)
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
  
  // MARK: Layout
  private func setupLayout() {
    setupTitleLabel()
    setupDescriptionLabel()
    setupDifficultyTitleLabel()
    setupInstructionTitleLabel()
    setupInstructionLabel()
    setupDateLabel()
    
    
    addSubview(titleLabel)
    addSubview(dateLabel)
    addSubview(descriptionLabel)
    addSubview(difficultyTitleLabel)
    addSubview(instructionTitleLabel)
    addSubview(instructionLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self).offset(20)
      make.leading.equalTo(self).inset(20)
      make.trailing.equalTo(self).inset(94)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.bottom.equalTo(titleLabel)
      make.trailing.equalTo(self).inset(24)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(self).inset(24)
      make.trailing.equalTo(self).inset(24)
    }
    
    difficultyTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
      make.leading.equalTo(self).inset(24)
      make.trailing.equalTo(self).inset(24)
    }
    
    instructionTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(difficultyTitleLabel.snp.bottom).offset(44)
      make.leading.equalTo(self).inset(24)
      make.trailing.equalTo(self).inset(24)
    }
    
    instructionLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionTitleLabel.snp.bottom).offset(8)
      make.leading.equalTo(self).inset(24)
      make.trailing.equalTo(self).inset(24)
    }
    
    self.snp.makeConstraints { (make) in
      make.bottom.equalTo(instructionLabel.snp.bottom)
    }
  }
  
  private func setupTitleLabel() {
    titleLabel.textColor = .basic1
    titleLabel.font = .basic1
    titleLabel.numberOfLines = 0
  }
  
  private func setupDescriptionLabel() {
    descriptionLabel.textColor = .basic2
    descriptionLabel.font = .basic3
    descriptionLabel.numberOfLines = 0
  }
  
  private func setupDifficultyTitleLabel() {
    difficultyTitleLabel.textColor = .basic1
    difficultyTitleLabel.font = .basic4
  }
  
  private func setupInstructionTitleLabel() {
    instructionTitleLabel.textColor = .basic1
    instructionTitleLabel.font = .basic4
  }
  
  private func setupInstructionLabel() {
    instructionLabel.textColor = .basic2
    instructionLabel.font = .basic3
  }
  
  private func setupDateLabel() {
    dateLabel.textColor = .basic1
    dateLabel.font = .basic3
    dateLabel.textAlignment = .right
  }

}


    
  
