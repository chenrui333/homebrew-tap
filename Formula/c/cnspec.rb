class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.12.1.tar.gz"
  sha256 "7001843f31859a30203e7cb6399bcceb86f8f11de566f07e43dc388ae04830fa"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd98fbf7fed42784dca37ea8b800356030ebe8395b0a5ad2ab7da801d198d14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc4e116fba486ccd6b9b1611d84d32a2c4ff17d415a2ca91c14b187d6519b857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be697de695c1a3a6ac9ea1cf5d97848147ddd614d2ee84cc1bfb6edd2f4b8b2"
    sha256 cellar: :any,                 x86_64_linux:  "f30e71c92a813e3ec85da55ba05a56928a9a6837c0503026234856bb5687192c"
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
