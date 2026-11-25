class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.14.0.tar.gz"
  sha256 "8bd0413ed29d86a1d0fa7c7121ffdc2f62fe72b9bb0d1264020874de2e041b8a"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8ae8a117cf24aa05a3a5e285e4243065f7d3904460e3fadc7aa8ed2c3fc92791"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b032d855fca786c94f124285c00c42d5f025c2e1c43811be2a2cb134046358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e91b022179423b038ceb0f29678e7f200401733977c09a54316ccc61759cef01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e3c750be598f52b0ffc481f34effabd071a729c2babf8d5eeeb56584700bcd"
    sha256 cellar: :any,                 x86_64_linux:  "e68cf936961279652d4dff14f60e952f54a832058e53b4d65841d4298432a15e"
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
