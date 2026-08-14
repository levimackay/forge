import Testing
import ForgeKit
@testable import ForgeData

@Test("ForgeData can reach the domain module it is built on")
func dependsOnForgeKit() {
    #expect(ModuleInfo.name == "ForgeKit")
}
