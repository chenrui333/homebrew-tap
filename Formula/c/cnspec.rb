class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.13.1.tar.gz"
  sha256 "3a9ccf09c92eb3341e51c866acdf439da24e88e7069444884dd6a3b74a74470f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4309d1734f4ee4b014c0a77880cd0732a1eb7bae976d9dccb54eb82d683f5807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4b5126db77ca9eaa77961e1a67c6c211925ff22c3efc5ef6246d57fa74a5e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e34ae6cfc9a6a47ddf8ead3ef8e640f0de505896521c09be0ca04f8c34af22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded26d6d9f8fb4b4e88d692ac75ce3ebf833f0db4b8274d0aba2cc0a54ab76d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10bfb83fa9ae1cd230bfffdce9eec5165649517ff3d41836d88bc1b1bf6ef70"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
