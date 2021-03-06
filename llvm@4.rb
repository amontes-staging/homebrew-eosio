class LlvmAT4 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm-mirror/llvm.git",
    :branch   => "release_40",
    :revision => "c8fccc53ed66d505898f8850bcc690c977a7c9a7"
  version "4.0.1"

  bottle do
    root_url "https://eos-public-oss-binaries.s3-us-west-2.amazonaws.com"
    sha256 "4d99b806e7a2ef4629f9f66b0b3221a9b79053dfd082a002b502e67e466851d0" => :catalina
    sha256 "dfe7ccdcdb7b081cdeb80d158cea12c3f341eb0db3cb8b717c15522acf489e7a" => :mojave
    cellar :any
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "cmake" => :build
  depends_on "libffi"

  def install
    ENV.libcxx if ENV.compiler == :clang
    ENV.permit_arch_flags

    args = %W[
      -DLLVM_TARGETS_TO_BUILD='host'
      -DLLVM_BUILD_TOOLS=false
      -DLLVM_ENABLE_RTTI=1
      -DCMAKE_BUILD_TYPE=Release
    ]

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make -j#{ENV.make_jobs}"
      system "make", "install"
    end
    (share/"cmake").install "cmake/modules"
  end
end
