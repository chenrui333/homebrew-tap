class Kbst < Formula
  desc "Kubestack framework CLI"
  homepage "https://www.kubestack.com/"
  url "https://github.com/kbst/kbst/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a02615028a00f4ce1e0121f3c8822dc5245f79e4e34bb85de48cc6ba6b3d5047"
  license "Apache-2.0"
  head "https://github.com/kbst/kbst.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "856e79443d524a098fbea6ae09243b9ec6dd02413391438171489ab2ee42263e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8831de59cf8ec6713623cbc74cd5249cd041fe80d99877270d1868c232e2ea6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b9d56dcf3ec877112b026bb3a5003de94d0e6c75788bdb8d431ce5322a28207"
    sha256 cellar: :any,                 x86_64_linux:  "3f87cecae988f0322f97282f54b4a5bcc6f3f625d6d9763e1cf079c9b89f9a53"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kbst", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbst --version")

    # Functional commands download the Kubestack catalog; cobra validates arguments before that.
    output = shell_output("#{bin}/kbst init aks example.com 2>&1", 1)
    assert_match "accepts 4 arg(s), received 1", output
    refute_path_exists testpath/"kubestack-starter-aks"
  end
end
