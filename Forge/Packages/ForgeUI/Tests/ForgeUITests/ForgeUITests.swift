import Testing
import ForgeKit
@testable import ForgeUI

@Test("ForgeUI can reach the domain module it renders")
func dependsOnForgeKit() {
    #expect(ModuleInfo.name == "ForgeKit")
}
