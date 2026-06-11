class HarViewer < Formula
  desc "Terminal UI for inspecting HAR files"
  homepage "https://github.com/nassendelft/har-viewer"
  url "https://github.com/nassendelft/har-viewer/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "aefa9ee0d4b1747a8aeb8d96b9c68c4e03c6847422a05fb42215fc11cf43f542"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "openjdk@17" => :build

  on_linux do
    depends_on "gcc" => :build
    depends_on arch: :x86_64
  end

  resource "ftxui" do
    url "https://github.com/ArthurSonzogni/FTXUI/archive/c6be538bc442b59e3a533b0fc48f72e0d5b70307.tar.gz"
    sha256 "6e5c2b4e2d1afca978dcf6e597dcf489f70cc4893c70b01041c8b513e3b48e23"
  end

  def install
    ENV["GRADLE_USER_HOME"] = buildpath/".gradle"
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    ENV["KONAN_DATA_DIR"] = buildpath/".konan"

    resource("ftxui").stage buildpath/"vendor/ftxui"

    inreplace "app/build.gradle.kts",
              '"macosArm64" -> macosArm64()',
              %Q("macosArm64" -> macosArm64()\n        "macosX64" -> macosX64())
    inreplace "ftxui-kt/build.gradle.kts",
              '"macosArm64" -> macosArm64()',
              %Q("macosArm64" -> macosArm64()\n        "macosX64" -> macosX64())

    if OS.linux?
      gcc = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version.major}"
      libstdcxx = Utils.safe_popen_read(gcc.to_s, "-print-file-name=libstdc++.a").chomp
      inreplace "app/build.gradle.kts", "/usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.a", libstdcxx
      inreplace "ftxui-kt/src/nativeInterop/cinterop/ftxui_c.def",
                "/usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.a", libstdcxx
    end

    target = if OS.mac?
      Hardware::CPU.arm? ? "macosArm64" : "macosX64"
    else
      "linuxX64"
    end

    gradle_target = target.sub(/\A./, &:upcase)
    system "./gradlew", ":app:linkReleaseExecutable#{gradle_target}", "--no-daemon"
    bin.install "app/build/bin/#{target}/releaseExecutable/app.kexe" => "har-view"
  end

  test do
    assert_match "Usage: har-viewer <file.har>", shell_output("#{bin}/har-view")

    (testpath/"empty.har").write <<~JSON
      {
        "log": {
          "version": "1.2",
          "creator": {
            "name": "homebrew-test",
            "version": "1.0"
          },
          "entries": []
        }
      }
    JSON
    assert_match "No entries found in HAR file.", shell_output("#{bin}/har-view #{testpath}/empty.har")
  end
end
