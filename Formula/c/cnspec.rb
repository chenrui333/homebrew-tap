class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.30.0.tar.gz"
  sha256 "8e85e72fb1d4acf3d79a82f6eef86cbd24f38b96d8ebea26100dcc8b39f72c11"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b4e09fe3a4c8a14d09020dc870d43ae96a89dbcea621512798a0afdff7962f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6910be67f4bbcbc78f3e51689cef787dd82858faeff2c9526a583d9efe00f2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b31b0892ac2411107b962f22b83e70fb3407d97a1ddbc816158c61f266a6668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b7887d65f55cd3c5fd07f884b20fc4357ac50c31a325c6f8dfe055a18649bf"
    sha256 cellar: :any,                 x86_64_linux:  "3e8e03154f81ee3e76eb7b40da08ee3e066f554e972c9ea3620af0c13ea7f656"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
