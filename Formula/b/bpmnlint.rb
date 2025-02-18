class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.2.0.tgz"
  sha256 "9d9a85df49b3eb51bf5d7f698abd2c9e223f18cba0077b86e5110764d68e8c55"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794658aa3af311167663d13a40ad101d119cbe7c4625b4e2ce9e3c452bf7dc45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28505a56febb6a9837ebdfe408eb3962e6edcd80a190248373808c00e8f43887"
    sha256 cellar: :any_skip_relocation, ventura:       "763377fcc30d3202ffa7e86a69903fd0096b8a54f526914c13e6c3f78f0abdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca14fe13b77ddebf34a4105b3fc87eb8410b037a4eaae0a90aaab85dbe9416c"
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
