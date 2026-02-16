class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.0.0-pre1.tar.gz"
  sha256 "95f08f2da6c702973523fb62ea421d92e5a74c2797f9e6cffc57c2b5c9fb50db"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8314a0f1be2290bc15d547a19e8d7fbad5bb4f8673df869ab003e808c9ac9f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47fe80d9483e91d95e2e559d8b045d36473dc47ce1961103023dd366a77e7b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a553d2d1f13622d7ce8a896c22318e32e5d79badb3f5df552af023aa70ac1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8421f88410949ff1d790093665ad4ed5933336f6dbbdabc6e9a2b29239e4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a21c15c8f896e1124569bc44f5396d9daf3a3be30a32d42cb6de6d1fa3c0d5"
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
