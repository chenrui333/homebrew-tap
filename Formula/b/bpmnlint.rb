class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.4.0.tgz"
  sha256 "04f2e1de49998b8c7d74d2beed8662b689b4022c86d90291dfc4fa86cf7068f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9822f8fb49f1599d3ab8738f918b5bce2419671205f2fe49f2f265823f0aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba6c15d18adf15cf74b708608db0969fc600926b4cdb90bec61da1c6b3dac0c"
    sha256 cellar: :any_skip_relocation, ventura:       "bb194c80ac68da5fd070f0f8d6f51da82fa218e8ea84b920aa5238b814cdc236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dd98bc3e4a51adef3840184800c09ffeee1e19f7eeddb0b5a8b6e8d5cb077c"
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
