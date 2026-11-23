class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.13.0.tar.gz"
  sha256 "547c9b3945e0ab8c7e3fbd061a446fcfc6d56b305c7092394eecab5c7bedb623"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b20832a0e753dda78378a409b6d16109204b1ea18d7e5169ae078a12a93aceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38679745ea647bd17075861a0187460e7530962ffd25442e7fed84c9618f9a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ee0f0f4fa31e7b131cf4b852a1d2283b3ef4bf90f457179ecede7f37bb44cb"
    sha256 cellar: :any,                 x86_64_linux:  "b22bf1cb38f8f1f5f052f44a1de95ed105363bbd9e7c76e4c6302154356798e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec --auto-update=false version")

    output = shell_output("#{bin}/cnspec --auto-update=false policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
