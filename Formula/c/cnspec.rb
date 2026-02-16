class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.0.0-pre1.tar.gz"
  sha256 "95f08f2da6c702973523fb62ea421d92e5a74c2797f9e6cffc57c2b5c9fb50db"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e528d677563a6c8b8f87541104edc74ec7025c2582ba42e392b627c82eaede1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4708ad2492e70530c6fadcd25e5075969bacbb83f0f99e147a47d53a3172749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d05c88dc57f17879ec1ff29b7ba5edf103d67ad3fb38210e54523acf69faacf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738243fbff84714dc4ab2cda1f7aa7212ec92549dbff122a4034e6c1c84bb473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21dfdca3fbd6ff312c04d32a8c55563b7a7a4d923131523667503a663002ae2d"
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
