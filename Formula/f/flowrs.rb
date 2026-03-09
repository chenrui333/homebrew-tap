class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "48c4e87132ce8c9469cd471eb1e21c18ac0d60ea889188197f11504300a022d7"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bb9fb3b4704750fc5befdce9080d17193175053be95b030baaa868b026183b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e053f7b2b08236188a31ef4edea699e063130d57ea80f53cbb57a669bd96780"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02bf6d637543b360300fd6218fb6a4eeaba2c8aa8d30fbfc963c5a5ac7e9d479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de6c23c365016222279908481570409dddedddf542298493651be7f9154d9994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0fd6936bd9723fff556ba2eb3437ea3369aeb7f4dc809e62ec8c0955b5d979"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
