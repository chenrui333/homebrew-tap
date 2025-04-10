class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.5.tar.gz"
  sha256 "1098ada272fb1bd711131601330f26353aec6901855ee8e2d83621d617128e73"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2688981a9c68e905a801879bccb1c505184c3750747834f13b91a8db940a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5999a575adb3abc9f858a8fd5acc00e6779c075b29b133c3f11a05a5b9f380d0"
    sha256 cellar: :any_skip_relocation, ventura:       "63556f44b0cadce655841e9c5de7347540829ec50c32bccd359cd80a39776793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d4c29174b478980e6c1cccd4cc5e008cf10b3f759091369f022cb38bb90960"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
