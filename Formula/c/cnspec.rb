class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.27.0.tar.gz"
  sha256 "6768473bfcab57e71b48cc7482061e37c62c3189fd84429d1b92d0138ff3eeae"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9a5beefdc14fe8f20c59e3cac828499ec312f491b9f997e9aae344b75d8a656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f189c9b8a88aa99e2ca24908abbfe9d3c48bb6bd3371f9d7acef18d50640610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7338798886e243fd8564c9029600e019f0093f24c418a9c355e0df08bede6890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d28c79e52e36e373b3b75eb0a6ca09cdd7f663ccd0443704f2f40fd5311516"
    sha256 cellar: :any,                 x86_64_linux:  "4f74a95900a84144febdbf5a0ee807341e16221f5982434ab8e4b30c346c7274"
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
