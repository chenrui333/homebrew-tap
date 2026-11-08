class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.10.1.tar.gz"
  sha256 "714ff451c0f433594b1df6f1193db5413bc5d98c2e24358f39d17c1e0e54e0bf"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a99453f39786f08f528198b0f620a1ec11121a8d6563c84ba0713c9d4ff9da54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0468b3a38cc8fc32872d305e700cfcfeb1d3b12abd973726df493e0b18c148c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52fbbed37cc135c02ffa7486c3782b7d3da5163ad394f45a06f1ea5269d3a507"
    sha256 cellar: :any,                 x86_64_linux:  "e06d9a22ecba7d36d0111a0ddcdc65626c6c8cbc05e2015b163fd8a23e7e4595"
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
