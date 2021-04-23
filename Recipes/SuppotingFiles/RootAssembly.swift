import Foundation

class RootAssembly {
  lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
  private var serviceAssembly: ServiceAssemblyProtocol = ServiceAssembly()
}
