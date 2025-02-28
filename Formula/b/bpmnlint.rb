class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.4.1.tgz"
  sha256 "a008dedb7a1a73f1d7373f139aefe899ba195cb3b360fced88f4b003311ab841"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ca8840ded159b627f43b050563772f40deda6aaa263affb1aecf82c05b01b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ca67d5e9a8ffa526abac926a5314fd062dfefe5d63e958faf02078c11c8138"
    sha256 cellar: :any_skip_relocation, ventura:       "24a17edc0f17a09afa2202c707240dfab02120571df4947e758beee8be09d335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67929ad9e62134e59f3349ef9496b1e542c7a720e350c46f1a143896206a4c24"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/bpmnlint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bpmnlint --version")

    system bin/"bpmnlint", "--init"
    assert_match "\"extends\": \"bpmnlint:recommended\"", (testpath/".bpmnlintrc").read

    (testpath/"diagram.bpmn").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Definitions_1">
        <bpmn:process id="Process_1" isExecutable="false">
          <bpmn:startEvent id="StartEvent_1"/>
        </bpmn:process>
      </bpmn:definitions>
    XML

    output = shell_output("#{bin}/bpmnlint diagram.bpmn 2>&1", 1)
    assert_match "Process_1     error  Process is missing end event   end-event-required", output
  end
end
