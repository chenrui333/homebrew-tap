# framework: cobra
class Tftarget < Formula
  desc "Interactivity select resource to ( plan | apply | destroy ) with target option"
  homepage "https://github.com/future-architect/tftarget"
  url "https://github.com/future-architect/tftarget/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "c68ad9cc23f0ae1ac735dc74e98e340512be6b3ba4dd5cf2925caf6f5cb1cc13"
  license "MIT"
  head "https://github.com/future-architect/tftarget.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45f35153fb34ca77db5f36da0ef07616d1c164260b069ce69bbaef4fe2d50a65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f35153fb34ca77db5f36da0ef07616d1c164260b069ce69bbaef4fe2d50a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f35153fb34ca77db5f36da0ef07616d1c164260b069ce69bbaef4fe2d50a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b05bbce5269e953c9f4e8e12d717837e3d3d604be422f8e39ce99dd37775a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7582b53e410bcd2b52b699ebf46e56acaf51039dfa24d167c90da37157efd54"
  end

  depends_on "go" => :build
  depends_on "opentofu"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tftarget", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tftarget --version")

    output = shell_output("#{bin}/tftarget plan --executable tofu 2>&1", 1)
    assert_match "Error: No configuration files", output
  end
end
