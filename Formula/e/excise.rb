class Excise < Formula
  desc "Surgical terminal storage navigator"
  homepage "https://github.com/findyourexit/excise"
  url "https://github.com/findyourexit/excise/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "6f63c0f5f41d78b7ae74c9df7af9e996ffb69617cbde12d7488a511fbe4004ad"
  license "MIT"
  head "https://github.com/findyourexit/excise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebd99e5a7a96eb3d1c06ab2ca5c43ea6416e8f43e2d83b65caa94c4314707b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a9f38c25f5fbf1ef09f49485d2b66e6bc70e59f35a698f117c759f610f54f22"
    sha256 cellar: :any,                 arm64_linux:   "e285e7dc4a9816084546d8ad9a7dc92f73013e1891097b413a2c9fc5fe9b63b7"
    sha256 cellar: :any,                 x86_64_linux:  "ee2866ee6ad5c073689c01be896672c7d40529d635de602a3d7998f32ed6f3a8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/excise --version")

    fixture = testpath/"fixture"
    (fixture/"nested").mkpath
    (fixture/"nested/file.txt").write("fixture data\n")
    report = testpath/"report.json"
    system bin/"excise", "--format", "json", "--output", report, fixture
    assert_path_exists report
    assert_match "file.txt", report.read
  end
end
