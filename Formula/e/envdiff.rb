class Envdiff < Formula
  desc "Tool to snapshot and diff environments"
  homepage "https://github.com/GBerghoff/envdiff"
  url "https://github.com/GBerghoff/envdiff/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "1d5b83553b2bf026cb17a813c1c9ff20626359ff171075905ebaf2fbfb50d8fc"
  license "MIT"
  head "https://github.com/GBerghoff/envdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a619afa4736964247d536547808f2fc31c182477c393210e4ac13453c44db1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a619afa4736964247d536547808f2fc31c182477c393210e4ac13453c44db1f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a619afa4736964247d536547808f2fc31c182477c393210e4ac13453c44db1f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b597916be394eafc9cbac9e820677dfcce41522ceeb1bd11772d1da96040e70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e45b69f62a2c7d952b1681744935ba2704c409c4b8cf9c1d553616f3e4319f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/envdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envdiff --version")

    system bin/"envdiff", "init"
    assert_path_exists testpath/"envdiff.yaml"

    system bin/"envdiff", "snapshot", "-o", "snapshot.json"
    assert_path_exists testpath/"snapshot.json"

    output = shell_output("#{bin}/envdiff render snapshot.json")
    assert_match "SYSTEM", output
    assert_match "RUNTIME", output
  end
end
