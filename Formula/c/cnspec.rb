class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.7.0.tar.gz"
  sha256 "e4fed3fa5b87c6c187b4509e87551860ee164f094932dfa3c9b76bcf1065c83f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b397507b3cf470e9aa87a4bf6d65555017052324f41ff5e3eecb5fb4de4014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7921e6d0ac002174577020288c39ddf8dd7732b08f0b7899aa9b8b926a6344b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd17ddfb3c8626176ab73c5e78efb0f681e79b69d0bcb095eb62c5662ee0ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7073458663935b24e34dc3eaa3396ca72008e53cfd3faeba027c1ba59c294650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720a152b0181ea43e61ce7d0272aa83b1f8bf020ffe3f5c94ba7437af8f58913"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
