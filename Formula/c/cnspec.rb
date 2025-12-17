class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.14.1.tar.gz"
  sha256 "6d6adf39e4bc9a045030d2e1a7a6058ae09c3750a073c6fe18e6d5256ade2231"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e400ac35bf08490c73289091ef23476e0b3d0dec28e88259abb41e541c54877b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fc0ae157a1a25a0cff44c708342695b1a502950849ed9c5ffbd285f1af80f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4221ce8f8f6c1dc95aedd401845a491d5bf9c3ae2b585af99b8a6fc14a1b574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c66ce911fb24cb0a94ae30b479676546e500a204459057e2addfa8260f5f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34603fac2eca2eed068fafabcfcb324c717374946af2149186b3b78984ed52d6"
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
