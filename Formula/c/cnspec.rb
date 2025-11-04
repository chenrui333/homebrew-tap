class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.8.0.tar.gz"
  sha256 "4727438e5b0ce5962e54b3cbccd1c6d191cc75eff509ee6d524b5008c8d8a023"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "180d6274386ec2225f9f158713f36c285c945185bd11cbc8537be34b94697b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eb90c60066599e85a5a131fa53065b42e1fb2fd244cd84a917905fc7463b883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5366c5c36cc9df43b047044d72d8dc831bd3265e83b90b92f85b874cd14baf5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b65e016f6b8da2fa7f4fe7bbe2d466a395a9d31b1efc5023da6840501c34303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932cb19882276555190f1139794aa5a113f292080bf7a44276032508ad44d7c7"
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
