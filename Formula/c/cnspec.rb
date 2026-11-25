class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.14.0.tar.gz"
  sha256 "8bd0413ed29d86a1d0fa7c7121ffdc2f62fe72b9bb0d1264020874de2e041b8a"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d5252d5a5c7033a35a70967dc27f33c2bb7b0bbce2174dc7f73024818f64b2f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b71c138b003574ba6e8c22c7e4e071a6b0c9befc72a07af2d615668a5ed48a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab0dcf1e0ee4cc1df6aed80ad9ec3822e0818b5f3850da9efb6d056f30997c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06143ee40d5245d8ae538b3a8ba2400e8276f710d2906729104668ee300b0a09"
    sha256 cellar: :any,                 x86_64_linux:  "2462274df6ada5e9066f12617638ef4029cc24e802dd9bcc3251d5a4f265a4a2"
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
