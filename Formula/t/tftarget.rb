class Tftarget < Formula
  desc "Interactivity select resource to ( plan | apply | destroy ) with target option"
  homepage "https://github.com/future-architect/tftarget"
  url "https://github.com/future-architect/tftarget/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "c68ad9cc23f0ae1ac735dc74e98e340512be6b3ba4dd5cf2925caf6f5cb1cc13"
  license "MIT"
  head "https://github.com/future-architect/tftarget.git", branch: "main"

  depends_on "go" => :build
  depends_on "opentofu"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tftarget", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tftarget --version")

    output = shell_output("#{bin}/tftarget plan --executable tofu 2>&1", 1)
    assert_match "Error: No configuration files", output
  end
end
