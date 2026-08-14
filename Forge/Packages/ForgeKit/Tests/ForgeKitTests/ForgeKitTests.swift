import Testing
@testable import ForgeKit

@Test("ForgeKit exposes its module identity")
func moduleIdentity() {
    #expect(ModuleInfo.name == "ForgeKit")
}
