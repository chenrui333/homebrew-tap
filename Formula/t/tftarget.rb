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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a53d3517095858edeafeb7c2ed9756116a87201dfd54190d50c49ca6ba49537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ec7a291f2b961d4f016c33ee9b2411df3f0b1796f6f0e0f263f13e4cbcf4ac"
    sha256 cellar: :any_skip_relocation, ventura:       "583874019b91e16940636864e9fd0bcc0300abf477f5529032f4448c679f534c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c953d2538f62d69327698d518660887afba3378d033734e2a60f9ce9a569b9d1"
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
