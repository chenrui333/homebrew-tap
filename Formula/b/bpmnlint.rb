class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.3.0.tgz"
  sha256 "7900d579bbe3d0a31ce7b9caa7c3eab841d4e1dac1835e06b6b72294e2d7bbce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db0a4165518f55f619e954892b5a31f075bf13ddb0bab17ea29f1aa39602e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd17a9d1e87d670987c5ced7f703fa5b8405eef19205db7b18ace61fb1651334"
    sha256 cellar: :any_skip_relocation, ventura:       "fd98e2ed914e11383b1b88b3c63a07c25447ff3596e68a562817f09fa3541fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6f7ed67d8a9414ca1a4b4788686a5029c95e63e428bca773fb72617ad4bab4"
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
