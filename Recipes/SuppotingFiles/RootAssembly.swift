//
//  RootAssembly.swift
//  Recipes
//
//  Created by Алмат Кульбаев on 23.04.2021.
//

import Foundation

class RootAssembly {
  lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
  private var serviceAssembly: ServiceAssemblyProtocol = ServiceAssembly()
}
