class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.2.0.tar.gz"
  sha256 "80df18bad3ac151ed4ce9322ff6959b82de7a79e403d5233ddd43805592ffc48"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58f1eeaf36684a4a237eca16ad89cccfa0bd78335c17b7dedf4408f24bc2c402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73075abad4654048a6bcde1d25c4fff2af84d7915fbe681ef14a652177b13f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbabe05d6b1811886fabea36698e96990f8b27e6dd3087803e5e9a22ce17e13a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b086cf8976654bdded4a2974a2f1217deddc619e2474aeb01e54fb179127b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29d134f35b25449941702a6cc3afba9b9014a96810f91161333966272a81664"
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
